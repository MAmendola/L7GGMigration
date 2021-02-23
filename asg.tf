data "aws_availability_zones" "all" {}

resource "aws_security_group" "sec_group" {
  name = "sec_group"
  vpc_id = aws_vpc.team2vpc.id

  ingress {
    from_port   = var.http_port
    to_port     = var.http_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# resource "aws_launch_template" "web_tier_launch_template" {​​
# name_prefeix = "web_tier"
# image_id = var.ami
# instance_type = var.instance_type
# }​​

resource "aws_launch_template" "web_tier_launch_template" {
  name_prefix   = "web_tier"
  image_id      = var.ami
  instance_type = var.instance_type  #"t2.micro"
}





resource "aws_launch_configuration" "asg-launch-config-sample" {
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


resource "aws_security_group" "elb-sg" {
  name = "terraform-sample-elb-sg"
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

resource "aws_autoscaling_group" "asg-sample" {
  launch_configuration = aws_launch_configuration.asg-launch-config-sample.id
  availability_zones   = data.aws_availability_zones.all.names
  min_size = 6
  max_size = 12
  desired_capacity = 6

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
  # availability_zones = data.aws_availability_zones.all.names
  subnets           = [aws_subnet.public1.id, aws_subnet.public2.id]


#   health_check {
#     target              = "HTTP:${var.server_port}/"
#     interval            = 30
#     timeout             = 3
#     healthy_threshold   = 2
#     unhealthy_threshold = 2
#   }
  }


resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.web_lb.arn
  port              = var.http_port    #"443"
  protocol          = "HTTP"
  #ssl_policy        = "ELBSecurityPolicy-2016-08"
  #certificate_arn   = "arn:aws:iam::187416307283:server-certificate/test_cert_rab3wuqwgja25ct3n4jdj2tzu4"
 
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_tg.arn
  }
 
 
}

resource "aws_lb_target_group" "web_tg" {
  name     = "tf-example-lb-tg"
  port     = var.http_port
  protocol = "HTTP"
  vpc_id   = aws_vpc.team2vpc.id
}

# resource "aws_vpc" "main" {
#   cidr_block = "10.0.0.0/16"
# }




  # Adding a listener for incoming HTTP requests.
#   listener {
#     lb_port           = var.http_port
#     lb_protocol       = "http"
#     instance_port     = var.server_port
#     instance_protocol = "http"
#   }
# }   


# resource "aws_lb" "test" {
#   name               = "test-lb-tf"
#   internal           = false
#   load_balancer_type = "application"
#   security_groups    = [aws_security_group.lb_sg.id]
#   subnets            = aws_subnet.public.*.id

#   enable_deletion_protection = true

#   access_logs {
#     bucket  = aws_s3_bucket.lb_logs.bucket
#     prefix  = "test-lb"
#     enabled = true
#   }

#   tags = {
#     Environment = "production"
#   }
# }