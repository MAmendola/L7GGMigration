
variable "instance_type" {
  type        = string
  description = "This is my instance type"
  default = "t2.micro"
}

variable region {
  type = string
  default = "us-west-2"
}

# variable "key_name" {
#   type        = string
#   description = "Name of ssh key"
#   default = "my-key"
# }

variable "app_ec2_tags" {
  type = map
  default  = {
  Name = "app-tier"
}
}

variable "web_ec2_tags" {
  type = map
  default  = { 
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

variable "elb_port" {
  description = "The port the elb will be listening"
  type        = number
  default     = 80
} 

/*variable "subnet-ids" {
  type = string
  default = "subnet-0751eb0b, subnet-0a572c53, subnet-73c4e504, subnet-be690595,subnet-bf051385,subnet-c3ba25a6"
} 
*/

# variable "aws_amis" {
#   type = map
#   default = {
#     "us-east-1" = "ami-0739f8cdb239fe9ae"
#     "us-west-2" = "ami-008b09448b998a562"
#     "us-east-2" = "ami-0ebc8f6f580a04647"
#   }
# }

variable "ami" {
  type = string
  default = "ami-096fda3c22c1c990a"
}