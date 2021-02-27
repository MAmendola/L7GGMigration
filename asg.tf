
resource "aws_security_group" "sec_group" {
  name   = "sec_group"
  vpc_id = aws_vpc.team2vpc.id

  ingress {
    from_port       = var.http_port
    to_port         = var.http_port
    protocol        = "tcp"
    security_groups = [aws_security_group.elb-sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }



}

# resource "aws_launch_template" "web_tier_launch_template" {
#   name_prefix   = "web_tier"
#   image_id      = var.ami
#   instance_type = var.instance_type #"t2.micro"

#   vpc_security_group_ids = [aws_security_group.sec_group.id] # 02/24/2020 testing lb launch templete

# user_data = <<-EOF
#  #!/bin/bash
# sudo yum update
# sudo yum install -y httpd
# sudo chkconfig httpd on
# sudo service httpd start
# echo "<h1>Deployed via Terraform wih ELB</h1>" | sudo tee /var/www/html/index.html
# 	EOF	

# }





resource "aws_launch_configuration" "asg-launch-config-sample" {
  image_id        = var.ami
  instance_type   = var.instance_type
  security_groups = [aws_security_group.sec_group.id]

  user_data = <<-EOF
              #!/bin/bash -ex
              yum -y install httpd php mysql php-mysql
              chkconfig httpd on
              service httpd start
              if [ ! -f /var/www/html/lab-app.tgz ]; then
              cd /var/www/html
              wget https://aws-tc-largeobjects.s3-us-west-2.amazonaws.com/CUR-TF-200-ACACAD/studentdownload/lab-app.tgz
              tar xvfz lab-app.tgz
              chown apache:root /var/www/html/rds.conf.php
              fi
              EOF

  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_security_group" "elb-sg" {
  name   = "terraform-sample-elb-sg"
  vpc_id = aws_vpc.team2vpc.id
  # Allow all outbound
  # Inbound HTTP from anywhere

  ingress {
    from_port   = var.http_port
    to_port     = var.http_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }


}

resource "aws_autoscaling_group" "asg-sample" {
  launch_configuration = aws_launch_configuration.asg-launch-config-sample.id
  vpc_zone_identifier  = [aws_subnet.private1.id, aws_subnet.private2.id]
  min_size             = 6
  max_size             = 12
  desired_capacity     = 6

  # load_balancers    = [aws_lb.web_lb.name]
  target_group_arns = [aws_lb_target_group.web_tg.arn]

  health_check_type = "ELB"

  tag {
    key                 = "Name"
    value               = "terraform-asg-sample"
    propagate_at_launch = true
  }
}

resource "aws_lb" "web_lb" {
  name               = "web-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.elb-sg.id]
  subnets            = [aws_subnet.public1.id, aws_subnet.public2.id]


  # health_check {
  #   healthy_threshold   = 2
  #   unhealthy_threshold = 2
  #   timeout             = 3
  #   target              = "HTTP:80/index.html"
  #   interval            = 30
  # }




  # health_check {
  #   target              = "HTTP:${var.server_port}/"
  #   interval            = 300
  #   timeout             = 30
  #   healthy_threshold   = 20
  #   unhealthy_threshold = 20
  # }
}


resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.web_lb.arn
  port              = var.http_port
  protocol          = "HTTP"
  #ssl_policy        = "ELBSecurityPolicy-2016-08"
  #certificate_arn   = "arn:aws:iam::187416307283:server-certificate/test_cert_rab3wuqwgja25ct3n4jdj2tzu4"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_tg.arn
  }


}

resource "aws_lb_target_group" "web_tg" {
  name     = "tf-web-lb-tg"
  port     = var.http_port
  protocol = "HTTP"
  vpc_id   = aws_vpc.team2vpc.id


  health_check {
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 5

  }
}