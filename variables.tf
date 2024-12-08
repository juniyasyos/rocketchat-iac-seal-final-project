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
  default = []
}

variable "public_subnets" {
  default = []
}

variable "ip_secure" {
  description = "add your ip address"
  default     = ["160.187.37.4/32"]
}

variable "aws_region" {
  description = "aws region"
  type        = string
}

variable "instance_type_micro" {
  description = "ec2 instance type"
  type        = string
}

variable "instance_type_app" {
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
