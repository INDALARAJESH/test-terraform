output "sg_ids" {
  value = aws_security_group.sg.id
}
output "subnet_id" {
  value = aws_subnet.pub.id
}
output "key" {
    value = aws_key_pair.deployer.id
}
