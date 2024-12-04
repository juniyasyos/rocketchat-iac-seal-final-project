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

output "beanstalk_env_url" {
  description = "URL of the Elastic Beanstalk environment"
  value       = module.elastic_beanstalk.beanstalk_env_url
}

output "s3_bucket_name" {
  description = "Name of the S3 bucket"
  value       = module.s3_storage.s3_bucket_name
}