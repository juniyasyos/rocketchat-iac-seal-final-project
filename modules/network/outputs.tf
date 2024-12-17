output "private_subnets" {
  description = "private_subnets"
  value       = module.vpc.private_subnets
}
output "public_subnets" {
  description = "public_subnets"
  value       = module.vpc.public_subnets
}

output "keypair" {
  value = aws_key_pair.deployer.key_name
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "vpc_igw" {
  value = module.vpc.igw_id
}
# # Output untuk CIDR Blocks public_subnets
# output "public_subnets_blocks" {
#   value = [for i in range(length(aws_subnet.public)) : aws_subnet.public[i].cidr_block]
# }

# # Output untuk CIDR Blocks private_subnets
# output "private_subnets_blocks" {
#   value = [for i in range(length(aws_subnet.private)) : aws_subnet.private[i].cidr_block]
# }