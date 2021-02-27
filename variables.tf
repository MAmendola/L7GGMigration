
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

<<<<<<< HEAD
variable "users" {
  type        = list(string)
  description = "Users to create in a simple list format `[\"user1\", \"user2\"]. Use either variable `users` or `users_groups`"
  default     = ["sysadmin1", "sysadmin2", "dbadmin1", "dbadmin2", "monitoring_user_1", "monitoring_user_2", "monitoring_user_3", "monitoring_user_4"]
}


variable "create_access_keys" {
  type        = bool
  description = "Set to true to create programmatic access for all users"
  default     = true
}

# variable "create_login_profiles" {
#   type        = list(string)
#   description = "Set to true to create console access for all users"
#   default     = true
# }

variable "pgp_key" {
  type        = string
  description = "PGP key in plain text or using the format `keybase:username` to encrypt user keys and passwords"
  default     = "AKIAQWPSY6BWGNTFHBMT"
=======
variable "db_username" {
  description = "Database administrator username"
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "Database administrator password"
  type        = string
  sensitive   = true
>>>>>>> a6ed9011ad0aa0c8ebe3c21a27b617327bba9c2b
}