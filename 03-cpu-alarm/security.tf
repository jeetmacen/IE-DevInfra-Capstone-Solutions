# No ingress or egress rules: Terraform removes the default allow-all egress rule.
resource "aws_security_group" "isolated" {
  name_prefix = "${var.project_name}-"
  description = "No inbound or outbound traffic"
  vpc_id      = aws_vpc.main.id
}
