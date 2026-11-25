resource "aws_security_group" "web" {
  name_prefix = "${var.project_name}-"
  description = "HTTP from the internet; no SSH or RDP"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "HTTP"
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Package downloads"
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}
