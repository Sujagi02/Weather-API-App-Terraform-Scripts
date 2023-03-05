## Creating VPC
resource "aws_vpc" "weather-api-app-vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "weather-api-app-vpc"
  }
}

## Creating Subnet
resource "aws_subnet" "weather-api-app-subnet" {
  vpc_id                  = aws_vpc.weather-api-app-vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "weather-api-app-subnet"
  }
}

## Internet gateway
resource "aws_internet_gateway" "weather-api-app-igw" {
  vpc_id = aws_vpc.weather-api-app-vpc.id
  tags = {
    Name = "weather-api-app-igw"
  }
}

## Route table
resource "aws_route_table" "weather-api-app-route" {
  vpc_id = aws_vpc.weather-api-app-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.weather-api-app-igw.id
  }

  tags = {
    Name = "weather-api-app-rt"
  }
}

resource "aws_route_table_association" "weather-api-app-rta" {
  subnet_id      = aws_subnet.weather-api-app-subnet.id
  route_table_id = aws_route_table.weather-api-app-route.id
}


## Creating security group
resource "aws_security_group" "weather-api-app-sg" {
  name        = "weather-api-app-tf"
  description = "Security group from terraform"
  vpc_id      = aws_vpc.weather-api-app-vpc.id

  dynamic "ingress" {
    for_each = [22, 80, 443]
    iterator = port
    content {
      description = "Ports 80, 443, 22"
      from_port   = port.value
      to_port     = port.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "weather-api-app-tf"
  }
}

output "weather-api-app-sg" {
  value = aws_security_group.weather-api-app-sg.id
}