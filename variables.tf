
variable "instance_type" {
  type        = string
  description = "This is my instance type"
  default     = "t2.micro"
}

variable "region" {
  type    = string
  default = "us-west-2"
}

# variable "key_name" {
#   type        = string
#   description = "Name of ssh key"
#   default = "my-key"
# }

variable "app_ec2_tags" {
  type = map(any)
  default = {
    Name = "app-tier"
  }
}

variable "web_ec2_tags" {
  type = map(any)
  default = {
    Name = "web-tier"
  }
}

variable "external_ip" {
  type    = string
  default = "0.0.0.0/0"
}

variable "server_port" {
  description = "The port the web server will be listening"
  type        = number
  default     = 8080
}


variable "http_port" {
  description = "The port the elb will be listening"
  type        = number
  default     = 80
}


variable "ami" {
  type    = string
  default = "ami-0e999cbd62129e3b1"
}