data "aws_availability_zones" "all" {}

resource "aws_security_group" "sec_group_apptier" {
  name = "sec_group_apptier"
  vpc_id = aws_vpc.team2vpc.id

  ingress {
    from_port   = var.http_port
    to_port     = var.http_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}



resource "aws_launch_template" "app_tier_launch_template" {
  name_prefix   = "app_tier"
  image_id      = var.ami
  instance_type = var.instance_type  
}





resource "aws_launch_configuration" "asg-launch-config-apptier" {
  image_id          = var.ami
  instance_type = var.instance_type
  security_groups = [aws_security_group.sec_group.id]
  
  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, Terraform & AWS ASG" > index.html
              nohup busybox httpd -f -p "${var.server_port}" &
              EOF
  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_security_group" "lb-sg-apptier" {
  name = "terraform-lb-sg-apptier"
  vpc_id = aws_vpc.team2vpc.id
  # Allow all outbound
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # Inbound HTTP from anywhere
  ingress {
    from_port   = var.http_port
    to_port     = var.http_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_autoscaling_group" "asg-apptier" {
  launch_configuration = aws_launch_configuration.asg-launch-config-apptier.id
  vpc_zone_identifier = [aws_subnet.private3.id, aws_subnet.private4.id]
  min_size = 5
  max_size = 10
  desired_capacity = 5


  target_group_arns = [aws_lb_target_group.apptier_tg.arn]
  
  health_check_type = "ELB"

  tag {
    key                 = "Name"
    value               = "terraform-asg-apptier"
    propagate_at_launch = true
  }
}

resource "aws_lb" "apptier_lb" {
  name               = "apptier-lb"
  internal           = true #false changed to true for apptier 
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb-sg-apptier.id]
  subnets           = [aws_subnet.private3.id, aws_subnet.private4.id]


#   health_check {
#     target              = "HTTP:${var.server_port}/"
#     interval            = 30
#     timeout             = 3
#     healthy_threshold   = 2
#     unhealthy_threshold = 2
#   }
  }


resource "aws_lb_listener" "back_end" {
  load_balancer_arn = aws_lb.apptier_lb.arn
  port              = var.server_port    #"443"
  protocol          = "HTTP"
  #ssl_policy        = "ELBSecurityPolicy-2016-08"
  #certificate_arn   = "arn:aws:iam::187416307283:server-certificate/test_cert_rab3wuqwgja25ct3n4jdj2tzu4"
 
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.apptier_tg.arn
  }
}

resource "aws_lb_target_group" "apptier_tg" {
  name     = "tf-example-lb-tg"
  port     = var.server_port
  protocol = "HTTP"
  vpc_id   = aws_vpc.team2vpc.id
}