output "instance_id" {
  value = aws_instance.pulsefort.id
}

output "public_ip" {
  value = aws_eip.pulsefort.public_ip
}