output "ecs_sg_id" {
  value = aws_security_group.ecs_sg.id
}

output "sessions_sg_id" {
  value = aws_security_group.sessions_sg.id
}
