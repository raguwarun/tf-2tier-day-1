#Security Group
resource "aws_security_group" "two-tier-ec2-sg" {
  name = "two-tier-ec2-sg"
  description = "allow traffic from vpc"
  vpc_id = aws_vpc.two-tier-vpc.id
  depends_on = [
    aws_vpc.two-tier-vpc
  ]

  ingress {
    from_port = "0"
    to_port = "0"
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = "80"
    to_port = "80"
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = "22"
    to_port = "22"
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = "0"
    to_port = "0"
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags={
    Name="two-tier-ec2-sg"
  }
}

# Load Balancer security group
resource aws_security_group "two-tier-alb-sg"{
  name="two-tier-alb-sg"
  description = "load balancer security group"
  vpc_id = aws_vpc.two-tier-vpc.id
  depends_on = [
    aws_vpc.two-tier-vpc
  ]

  ingress {
    from_port = "0"
    to_port = "0"
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = "0"
    to_port = "0"
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags={
    Name ="two-tier-alb-sg"
  }
}

# Database tier Security Group
resource "aws_security_group" "two-tier-db-sg" {
  vpc_id = aws_vpc.two-tier-vpc.id
  name = "two-tier-db-sg"
  description = "allow traffic from internet"

  ingress {
    from_port = "3306"
    to_port = "3306"
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    security_groups = [aws_security_group.two-tier-ec2-sg.id]
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
    security_groups = [aws_security_group.two-tier-ec2-sg.id]
  }

  egress {
    from_port = "0"
    to_port = "0"
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
