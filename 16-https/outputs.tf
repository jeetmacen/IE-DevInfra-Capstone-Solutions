output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnets" {
  value = [aws_subnet.public_a.id, aws_subnet.public_b.id]
}

output "instance_id" {
  value = aws_instance.web.id
}

output "instance_public_ip" {
  value = aws_instance.web.public_ip
}

output "alb_dns_name" {
  value = aws_lb.main.dns_name
}

output "http_url" {
  value = "http://${aws_lb.main.dns_name}"
}

output "https_url" {
  value = "https://${aws_lb.main.dns_name}"
}

output "certificate_arn" {
  value = aws_acm_certificate.alb.arn
}

output "target_group_arn" {
  value = aws_lb_target_group.web.arn
}
