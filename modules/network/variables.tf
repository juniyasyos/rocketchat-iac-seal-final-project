variable "env" {
  description = "environment"
  type        = string
}
variable "vpc_name" {
  description = "name of vpc"
  type        = string
}
variable "cidr" {
  description = "cidr of vpc"
  type        = string
}
variable "azs" {
  description = "availability zones"
  type        = list(string)

}
variable "private_subnets" {
  description = "private subnets"
  type        = list(string)

}
variable "public_subnets" {
  description = "public subnets"
  type        = list(string)

}
variable "enable_nat_gateway" {
  description = "enable nat gateway"
  type        = bool
}
variable "enable_vpn_gateway" {
  description = "enable vpn gateway"
  type        = bool
}

variable "key_name" {
  description = "name of key pair"
  type        = string
}

