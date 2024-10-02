
provider "aws" {
  region = var.aws_region
}

# VPC
resource "aws_vpc" "${var.project_name}-${var.environment}-vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name        = "${var.project_name}-${var.environment}-vpc"
    project     = var.project_name
    environment = var.environment
    identify    = var.identify
    type        = "network"
  }
}

# Public Subnet
resource "aws_subnet" "${var.project_name}-${var.environment}-public-subnet" {
  vpc_id            = aws_vpc.${var.project_name}-${var.environment}-vpc.id
  cidr_block        = var.public_subnet_cidr
  map_public_ip_on_launch = true
  availability_zone = var.aws_availability_zone
  tags = {
    Name        = "${var.project_name}-${var.environment}-public-subnet"
    project     = var.project_name
    environment = var.environment
    identify    = var.identify
    type        = "network"
  }
}

# Private Subnet
resource "aws_subnet" "${var.project_name}-${var.environment}-private-subnet" {
  vpc_id            = aws_vpc.${var.project_name}-${var.environment}-vpc.id
  cidr_block        = var.private_subnet_cidr
  availability_zone = var.aws_availability_zone
  tags = {
    Name        = "${var.project_name}-${var.environment}-private-subnet"
    project     = var.project_name
    environment = var.environment
    identify    = var.identify
    type        = "network"
  }
}

# Internet Gateway (IGW) for Public Subnet
resource "aws_internet_gateway" "${var.project_name}-${var.environment}-igw" {
  vpc_id = aws_vpc.${var.project_name}-${var.environment}-vpc.id
  tags = {
    Name        = "${var.project_name}-${var.environment}-igw"
    project     = var.project_name
    environment = var.environment
    identify    = var.identify
    type        = "network"
  }
}

# Public Route Table
resource "aws_route_table" "${var.project_name}-${var.environment}-public-rt" {
  vpc_id = aws_vpc.${var.project_name}-${var.environment}-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.${var.project_name}-${var.environment}-igw.id
  }

  tags = {
    Name        = "${var.project_name}-${var.environment}-public-rt"
    project     = var.project_name
    environment = var.environment
    identify    = var.identify
    type        = "network"
  }
}

# Private Route Table
resource "aws_route_table" "${var.project_name}-${var.environment}-private-rt" {
  vpc_id = aws_vpc.${var.project_name}-${var.environment}-vpc.id

  tags = {
    Name        = "${var.project_name}-${var.environment}-private-rt"
    project     = var.project_name
    environment = var.environment
    identify    = var.identify
    type        = "network"
  }
}

# Public Route Table Association
resource "aws_route_table_association" "${var.project_name}-${var.environment}-public-association" {
  subnet_id      = aws_subnet.${var.project_name}-${var.environment}-public-subnet.id
  route_table_id = aws_route_table.${var.project_name}-${var.environment}-public-rt.id
}

# Private Route Table Association
resource "aws_route_table_association" "${var.project_name}-${var.environment}-private-association" {
  subnet_id      = aws_subnet.${var.project_name}-${var.environment}-private-subnet.id
  route_table_id = aws_route_table.${var.project_name}-${var.environment}-private-rt.id
}

# Public Security Group
resource "aws_security_group" "${var.project_name}-${var.environment}-public-sg" {
  vpc_id = aws_vpc.${var.project_name}-${var.environment}-vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.project_name}-${var.environment}-public-sg"
    project     = var.project_name
    environment = var.environment
    identify    = var.identify
    type        = "network"
  }
}

# Private Security Group
resource "aws_security_group" "${var.project_name}-${var.environment}-private-sg" {
  vpc_id = aws_vpc.${var.project_name}-${var.environment}-vpc.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"] # Allow traffic from within the VPC
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.project_name}-${var.environment}-private-sg"
    project     = var.project_name
    environment = var.environment
    identify    = var.identify
    type        = "network"
  }
}

# Public NACL
resource "aws_network_acl" "${var.project_name}-${var.environment}-public-nacl" {
  vpc_id = aws_vpc.${var.project_name}-${var.environment}-vpc.id

  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 80
    to_port    = 80
  }

  egress {
    protocol   = "tcp"
    rule_no    = 101
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 443
    to_port    = 443
  }

  tags = {
    Name        = "${var.project_name}-${var.environment}-public-nacl"
    project     = var.project_name
    environment = var.environment
    identify    = var.identify
    type        = "network"
  }
}

# Private NACL
resource "aws_network_acl" "${var.project_name}-${var.environment}-private-nacl" {
  vpc_id = aws_vpc.${var.project_name}-${var.environment}-vpc.id

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "10.0.0.0/16" # Allow internal VPC traffic
    from_port  = 3306
    to_port    = 3306
  }

  tags = {
    Name        = "${var.project_name}-${var.environment}-private-nacl"
    project     = var.project_name
    environment = var.environment
    identify    = var.identify
    type        = "network"
  }
}
