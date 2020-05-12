# Providers
provider "aws" {
  version = "~> 2.0"
  region  = var.aws-region
}

terraform {
  backend "s3" {}
}

# Resources
resource "aws_lb" "lb" {
  name               = var.project-name
  internal           = false
  load_balancer_type = "application"
  subnets            = var.load-balancer-subnet-ids
  security_groups    = [ var.load-balancer-security-group-id ]
}

resource "aws_lb_target_group" "lb" {
  name     = var.project-name
  port     = 8080
  protocol = "HTTP"
  vpc_id   = var.vpc-id
}

resource "aws_lb_listener" "lb" {
  load_balancer_arn = aws_lb.lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lb.arn
  }
}

resource "aws_launch_configuration" "tomcat" {
  associate_public_ip_address = false
  image_id                    = var.ami
  instance_type               = var.ec2-instance-type
  name_prefix                 = "tomcat-${var.project-name}-"
  security_groups             = [var.tomcat-security-group-id]
  key_name                    = var.key-name

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "tomcat" {
  desired_capacity     = 1
  launch_configuration = aws_launch_configuration.tomcat.id
  max_size             = 1
  min_size             = 1
  name                 = "tomcat-${var.project-name}"
  vpc_zone_identifier  = var.tomcat-subnet-ids
  health_check_grace_period = 300
  health_check_type = "EC2"
  target_group_arns = [ aws_lb_target_group.lb.arn ]

  tag {
    key                 = "Name"
    value               = "tomcat-${var.project-name}"
    propagate_at_launch = true
  }
}