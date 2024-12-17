# Output untuk ID dari AMI Ubuntu yang terbaru
output "ami_id" {
  value       = data.aws_ami.ubuntu.id
  description = "The ID of the latest Ubuntu AMI"
}

# Output untuk ID VPC yang terkait dengan tag 'rocket-chat-stag'
output "vpc_id" {
  value       = data.aws_vpc.rocket-chat.id
  description = "The ID of the VPC associated with the rocket-chat-stag tag"
}

# Output untuk ID subnet publik yang terkait dengan tag 'elb-dev' dalam VPC
output "subnet_id" {
  value       = data.aws_subnets.public.ids[0] # Mengambil ID subnet pertama dari hasil filter
  description = "The ID of the public subnet in the rocket-chat-stag VPC"
}

# Output untuk nama key pair yang digunakan untuk EC2 instance
output "key_pair_name" {
  value       = data.aws_key_pair.rocket_chat_key.key_name
  description = "The name of the EC2 key pair used"
}

# Output untuk daftar ID security group yang terkait dengan nama 'rocket-chat-stag-frontend-sg'
output "security_group_ids" {
  value       = data.aws_security_groups.rocket_chat_sgs.ids
  description = "The IDs of the security groups associated with the rocket-chat-stag-frontend-sg group in the VPC"
}

output "subnet_availability_zones" {
  value       = data.aws_subnets.subnets_in_vpc.ids
  description = "The Availability Zones of the subnets in the specified VPC"
}

# Outputs
output "public_subnets_ids" {
  value = aws_subnet.public[*].id
}

output "public_elb_subnets_ids" {
  value = aws_subnet.public_elb[*].id
}
