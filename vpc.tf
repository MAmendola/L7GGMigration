# 
resource "aws_vpc" "team2vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "main"
  }
}


#_________________________________________ Public Subnets

resource "aws_subnet" "public1" {
  vpc_id            = aws_vpc.team2vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-west-2a"

  tags = {
    Name = "Public Subnet1"
  }
}

resource "aws_subnet" "public2" {
  vpc_id            = aws_vpc.team2vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-west-2b"

  tags = {
    Name = "Public Subnet2"
  }
}

#__________________________________________ Private Subnets

resource "aws_subnet" "private1" {
  vpc_id            = aws_vpc.team2vpc.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "us-west-2a"
  tags = {
    Name = "Private Subnet1"
  }
}

resource "aws_subnet" "private2" {
  vpc_id            = aws_vpc.team2vpc.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "us-west-2b"
  tags = {
    Name = "Private Subnet2"
  }
}


resource "aws_subnet" "private3" {
  vpc_id            = aws_vpc.team2vpc.id
  cidr_block        = "10.0.5.0/24"
  availability_zone = "us-west-2a"
  tags = {
    Name = "Private Subnet3"
  }
}

resource "aws_subnet" "private4" {
  vpc_id            = aws_vpc.team2vpc.id
  cidr_block        = "10.0.6.0/24"
  availability_zone = "us-west-2b"
  tags = {
    Name = "Private Subnet4"
  }
}

resource "aws_subnet" "private5" {
  vpc_id            = aws_vpc.team2vpc.id
  cidr_block        = "10.0.7.0/24"
  availability_zone = "us-west-2a"
  tags = {
    Name = "Private Subnet5"
  }
}

resource "aws_subnet" "private6" {
  vpc_id            = aws_vpc.team2vpc.id
  cidr_block        = "10.0.8.0/24"
  availability_zone = "us-west-2b"
  tags = {
    Name = "Private Subnet6"
  }
}

#____________________________________________________ Internet Gateway

resource "aws_internet_gateway" "IG" {
  vpc_id = aws_vpc.team2vpc.id

  tags = {
    Name    = "Internet Gateway for VPC"
    Project = "GoGreen team 2"
  }
}

#__________________________________________________________________ Public Route Tables/Subnet Associations

resource "aws_route_table" "public_table_us-west-2a" {
  vpc_id = aws_vpc.team2vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IG.id


  }
}


resource "aws_route_table_association" "public_subnet_association-2a" {
  subnet_id      = aws_subnet.public1.id
  route_table_id = aws_route_table.public_table_us-west-2a.id
}

resource "aws_route_table" "public_table_us-west-2b" {
  vpc_id = aws_vpc.team2vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IG.id

  }
}

resource "aws_route_table_association" "public_subnet_association-2b" {
  subnet_id      = aws_subnet.public2.id
  route_table_id = aws_route_table.public_table_us-west-2b.id
}

#___________________________________________________________________________ Private Route Tables/Subnet Associations


resource "aws_route_table" "private_table_us-west-2a" {
  vpc_id = aws_vpc.team2vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat-2a.id

  }
}

resource "aws_route_table_association" "private1_subnet_association-2a" {
  subnet_id      = aws_subnet.private1.id
  route_table_id = aws_route_table.private_table_us-west-2a.id
}

resource "aws_route_table_association" "private3_subnet_association-2a" {
  subnet_id      = aws_subnet.private3.id
  route_table_id = aws_route_table.private_table_us-west-2a.id
}

resource "aws_route_table_association" "private5_subnet_association-2a" {
  subnet_id      = aws_subnet.private5.id
  route_table_id = aws_route_table.private_table_us-west-2a.id
}

resource "aws_route_table" "private_table_us-west-2b" {
  vpc_id = aws_vpc.team2vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat-2b.id

  }
}

resource "aws_route_table_association" "private2_subnet_association-2b" {
  subnet_id      = aws_subnet.private2.id
  route_table_id = aws_route_table.private_table_us-west-2b.id
}

resource "aws_route_table_association" "private4_subnet_association-2b" {
  subnet_id      = aws_subnet.private4.id
  route_table_id = aws_route_table.private_table_us-west-2b.id
}

resource "aws_route_table_association" "private6_subnet_association-2b" {
  subnet_id      = aws_subnet.private6.id
  route_table_id = aws_route_table.private_table_us-west-2b.id
}

#____________________________________________________________________________ Elastic IPs

resource "aws_eip" "elastic_ip-2a" {
  vpc = true

  depends_on = [aws_internet_gateway.IG]
}

resource "aws_eip" "elastic_ip-2b" {
  vpc = true

  depends_on = [aws_internet_gateway.IG]
}

#________________________________________________________________________________ NATs

resource "aws_nat_gateway" "nat-2a" {
  allocation_id = aws_eip.elastic_ip-2a.id
  subnet_id     = aws_subnet.public1.id
}

resource "aws_nat_gateway" "nat-2b" {
  allocation_id = aws_eip.elastic_ip-2b.id
  subnet_id     = aws_subnet.public2.id
}

>>>>>>> dev
