## Lets create VPC, Subnets, Route Tables and Associations, Internet Gateways ###

# VPC
resource "aws_vpc" "two-tier-vpc" {
  cidr_block= "10.0.0.0/16"
  tags = {
    Name = "2-tier-vpc"
  }
}

# Public subnets
resource "aws_subnet" "two-tier-pub-sub-1" {
  vpc_id = aws_vpc.two-tier-vpc.id
  cidr_block = "10.0.0.0/18"
  availability_zone = "ap-south-1a"
  map_public_ip_on_launch = "true"

  tags={
    Name="two-tier-pub-sub-1"
  }
}

resource "aws_subnet" "two-tier-pub-sub-2" {
  vpc_id        = aws_vpc.two-tier-vpc.id
  cidr_block = "10.0.64.0/18"
  availability_zone = "ap-south-1b"
  map_public_ip_on_launch = "true"

  tags={
    Name="two-tier-pub-sub-2"
  }
}

#Private Subnets
resource "aws_subnet" "two-tier-pvt-sub-1" {
  vpc_id = aws_vpc.two-tier-vpc.id
  cidr_block = "10.0.128.0/18"
  availability_zone = "ap-south-1a"
  map_public_ip_on_launch = "false"

  tags={
    Name="two-tier-pvt-sub-1"
  }
}

resource "aws_subnet" "two-tier-pvt-sub-2" {
  vpc_id = aws_vpc.two-tier-vpc.id
  cidr_block = "10.0.192.0/18"
  availability_zone = "ap-south-1b"
  map_public_ip_on_launch = "false"

  tags={
    Name="two-tier-pvt-sub-2"
  }
}

#Internet Gateway
resource "aws_internet_gateway" "two-tier-igw" {
  vpc_id = aws_vpc.two-tier-vpc.id
  tags={
    Name="two-tier-igw"
  }
}

#Route Table
resource "aws_route_table" "two-tier-pub-route" {
  vpc_id = aws_vpc.two-tier-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.two-tier-igw.id
  }
  tags={
    Name="two-tier-public-route-table"
  }
}

# Route Table Association
resource "aws_route_table_association" "two-tier-rt-as-1" {
  route_table_id = aws_route_table.two-tier-pub-route.id
  subnet_id = aws_subnet.two-tier-pub-sub-1.id
}

resource "aws_route_table_association" "two-tier-rt-as-2" {
  route_table_id = aws_route_table.two-tier-pub-route.id
  subnet_id = aws_subnet.two-tier-pub-sub-2.id
}

