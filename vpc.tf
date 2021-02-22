resource "aws_vpc" "team2vpc" {
  cidr_block       = "10.0.0.0/16"

  tags = {
    Name = "main"
  }
}