output "alb_sg_id" {
  description = "Security group ID of the ALB"
  value       = aws_security_group.alb_sg.id
}

output "alb_listener_http" {
  description = "HTTP ALB listener"
  value       = aws_lb_listener.http
}

output "alb_listener_https" {
  description = "HTTPS ALB listener"
  value       = aws_lb_listener.https
}

output "alb_target_group_gateway_arn" {
  description = "ALB target group - gateway service arn"
  value       = aws_lb_target_group.gateway.arn
}

output "alb_target_group_uploads_arn" {
  description = "ALB target group - uploads service arn"
  value       = aws_lb_target_group.uploads.arn
}

output "alb_listener_uploads_rule" {
  description = "ALB Listener path-based rule for uploads"
  value       = aws_lb_listener_rule.uploads_rule
}

output "alb_dns_name" {
  description = "DNS name of the ALB"
  value       = aws_lb.main.dns_name
}

output "alb_zone_id" {
  description = "Zone ID of the ALB"
  value       = aws_lb.main.zone_id
}
