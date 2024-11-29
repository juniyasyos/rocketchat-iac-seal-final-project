# Output untuk IP public instance
output "ip_instance" {
  description = "Public IP addresses of the instances"
  value       = [for instance in aws_instance.this : instance.public_ip]
}

# Output untuk Subnet VPC
output "vpc_subnet" {
  description = "Public Subnet ID"
  value       = aws_subnet.public1.id
}

# Output untuk Elastic IP
output "vpc_elastic_ip" {
  description = "Elastic IP address"
  value       = aws_eip.eip.public_ip
}

# Output untuk Route Table
output "vpc_route_table" {
  description = "Public Route Table ID"
  value       = aws_route_table.public.id
}

# Output untuk AMI Instance
output "instance_ami" {
  description = "AMI used by the instances"
  value       = [for instance in aws_instance.this : instance.ami]
}

# Output untuk Security Group Instance
output "instance_security_group" {
  description = "Security groups attached to instances"
  value       = [for instance in aws_instance.this : instance.security_groups]
}

# Output untuk Semua Security Groups di VPC
output "vpc_security_groups" {
  description = "Security group IDs in the VPC"
  value       = [
    aws_security_group.docker_k8s_testing.id
  ]
}
