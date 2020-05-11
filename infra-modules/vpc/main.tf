# Providers
provider "aws" {
  version = "~> 2.0"
  region  = var.aws-region
}

terraform {
  backend "s3" {}
}

# Datasets
data "aws_availability_zones" "available" {
  state = "available"
}

# Resources

# VPC
resource "aws_vpc" "main" {
  cidr_block                = "10.0.0.0/16"
  enable_dns_hostnames      = true

  tags = {
    Name = "${var.project-name}"
  }
}

# VPC configuration for public subnets
resource "aws_subnet" "public" {
  count = 3

  availability_zone = data.aws_availability_zones.available.names[count.index]
  cidr_block        = "10.0.${count.index}.0/24"
  vpc_id            = aws_vpc.main.id
  map_public_ip_on_launch = true

  tags = {
    Name = "public-${var.project-name}-${count.index}"
  }
}

resource "aws_internet_gateway" "public" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project-name}"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.public.id
  }

  tags = {
    Name = "internet-${var.project-name}"
  }
}

resource "aws_route_table_association" "public" {
  count = 3

  subnet_id      = aws_subnet.public.*.id[count.index]
  route_table_id = aws_route_table.public.id
}

# VPC configuration for private subnets
resource "aws_subnet" "private" {
  count = 3

  availability_zone = data.aws_availability_zones.available.names[count.index]
  cidr_block        = "10.0.${count.index + 10}.0/24"
  vpc_id            = aws_vpc.main.id

  tags = {
    Name = "private-${var.project-name}-${count.index}"
  }
}

resource "aws_eip" "private" {
  vpc = true

  tags = {
    Name = "${var.project-name}"
  }

  depends_on = [ aws_internet_gateway.public ]
}

resource "aws_nat_gateway" "private" {
  allocation_id = aws_eip.private.id
  subnet_id     = aws_subnet.public.*.id[0]

  tags = {
    Name = "${var.project-name}"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.private.id
  }

  tags = {
    Name = "nat-${var.project-name}"
  }
}

resource "aws_route_table_association" "private" {
  count = 3

  subnet_id      = aws_subnet.private.*.id[count.index]
  route_table_id = aws_route_table.private.id
}

# Security Group configuration for the Load Balancer
resource "aws_security_group" "lb" {
  name        = "Load Balancer Security Group"
  description = "Port access configuration for the Load Balancer"
  vpc_id      = aws_vpc.main.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "lb-${var.project-name}"
  }
}

resource "aws_security_group_rule" "tomcat-vms" {
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Allow 80 port access to Tomcat VMs"
  from_port         = 80
  protocol          = "tcp"
  security_group_id = aws_security_group.lb.id
  to_port           = 80
  type              = "ingress"
}

# Security Group configuration for the Tomcat VMs
resource "aws_security_group" "tomcat" {
  name        = "Tomcat Security Group"
  description = "Port access configuration for the Tomcat VMs"
  vpc_id      = aws_vpc.main.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "tomcat-${var.project-name}"
  }
}

resource "aws_security_group_rule" "lb-tomcat-vms" {
  description              = "Allow access to Tomcat VMs from Load Balancer"
  from_port                = 8080
  protocol                 = "tcp"
  security_group_id        = aws_security_group.tomcat.id
  source_security_group_id = aws_security_group.lb.id
  to_port                  = 8080
  type                     = "ingress"
}

# Security Group configuration for the RDS
resource "aws_security_group" "rds" {
  name        = "RDS Security Group"
  description = "Port access configuration for the RDS instance"
  vpc_id      = aws_vpc.main.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "rds-${var.project-name}"
  }
}

resource "aws_security_group_rule" "tomcat-vms-rds" {
  description              = "Allow access to RDS instance from Tomcat VMs"
  from_port                = 3306
  protocol                 = "tcp"
  security_group_id        = aws_security_group.tomcat.id
  source_security_group_id = aws_security_group.tomcat.id
  to_port                  = 3306
  type                     = "ingress"
}
