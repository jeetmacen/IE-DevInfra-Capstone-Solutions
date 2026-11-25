resource "aws_security_group" "backup" {
  name        = "${var.project_name}-no-ingress"
  description = "Project 19: no inbound access; administration uses SSM"
  vpc_id      = var.vpc_id

  # Intentionally no ingress blocks. Ports 22 and 3389 are not open.
  egress {
    description = "HTTPS and package/service access through the selected subnet"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-no-ingress"
  }
}
