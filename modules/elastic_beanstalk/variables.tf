variable "env" {
  description = "Environment (e.g., development, staging, production)"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type for Elastic Beanstalk"
  type        = string
}

variable "mongodb_url" {
  description = "MongoDB connection string"
  type        = string
}

variable "root_url" {
  description = "Rocket.Chat ROOT_URL"
  type        = string
}
