resource "aws_security_group" "isolated" {
  name_prefix = "${var.project_name}-"
  description = "No inbound or outbound traffic"
  vpc_id      = data.aws_vpc.default.id
}
