# Output untuk IP public instance
output "ip_instance" {
  description = "Public IP addresses of the instances"
  value       = [for instance in aws_instance.this : instance.public_ip]
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

output "elastic_ips_env" {
  value       = local_file.env_file.content
  description = "Content of the .env file with Elastic IPs"
}
