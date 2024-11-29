variable "env" {
  description = "environment"
  type        = string
}
variable "vpc_name" {
  description = "name of vpc"
  type        = string
}
variable "vpc_cidr" {
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

variable "aws_region" {
  description = "aws region"
  type        = string
}

variable "instance_type" {
  description = "ec2 instance type"
  type        = string
}

variable "instance_storage" {
  description = "ec2 instance volume storage"
  type        = number
}

variable "key_name" {
  description = "name of key pair"
  type        = string
}
variable "mongodb_url" {
  description = "mongodb_url"
  type        = string
}

variable "mongodb_oplog_url" {
  description = "MongoDB endpoint to the local database"
  type        = string
}
variable "root_url" {
  description = "password"
  type        = string
}
variable "port" {
  description = "port"
  type        = number
}

variable "host_port" {
  description = "port"
  type        = number
}
