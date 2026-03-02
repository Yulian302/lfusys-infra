output "vpc_id" {
  value = aws_vpc.lfusysvpc.id
}

output "subnet_public_ids" {
  value = aws_subnet.public[*].id
}

output "subnet_private_ids" {
  value = aws_subnet.private[*].id
}
