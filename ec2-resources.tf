resource "aws_instance" "two-tier-web-1" {
  subnet_id = aws_subnet.two-tier-pub-sub-1.id
  ami ="ami-076c6dbba59aa92e6"
  instance_type = "t2.micro"
  security_groups = [aws_security_group.two-tier-ec2-sg.id]
  key_name = "two-tier-key"

  tags={
    Name="two-tier-web-server-1"
  }

  user_data = <<-EOF
#!/bin/bash
sudo yum update -y
sudo amazon-linux-extras install nginx1 -y
sudo systemctl enable nginx
sudo systemctl start nginx
EOF
}

resource "aws_instance" "two-tier-web-2" {
  subnet_id = aws_subnet.two-tier-pub-sub-2.id
  ami="ami-076c6dbba59aa92e6"
  instance_type = "t2.micro"
  security_groups = [aws_security_group.two-tier-ec2-sg.id]
  key_name = "two-tier-key"

  tags={
    Name="two-tier-web-server-2"
  }

  user_data = <<-EOF
#!/bin/bash
sudo yum update -y
sudo amazon-linux-extras install nginx1 -y
sudo systemctl enable nginx
sudo systemctl start nginx
EOF
}

# create EIPs for public access, no option directly from ec2 instance resource
resource "aws_eip" "two-tier-web-1-eip" {
  instance = aws_instance.two-tier-web-1.id
  depends_on = [aws_internet_gateway.two-tier-igw]
}

resource "aws_eip" "two-tier-web-2-eip" {
  instance = aws_instance.two-tier-web-2.id
  depends_on = [aws_internet_gateway.two-tier-igw]
}
