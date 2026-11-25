resource "aws_security_group" "alb" {
  name_prefix = "${var.project_name}-alb-"
  description = "Public HTTP to the load balancer"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "HTTP from the internet"
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "HTTP to targets"
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = [data.aws_vpc.default.cidr_block]
  }
}

# Targets accept HTTP only from the ALB; there is no SSH/RDP.
resource "aws_security_group" "targets" {
  name_prefix = "${var.project_name}-targets-"
  description = "HTTP from the ALB only"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description     = "HTTP from the ALB"
    protocol        = "tcp"
    from_port       = 80
    to_port         = 80
    security_groups = [aws_security_group.alb.id]
  }

  egress {
    description = "Package downloads"
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}
