# Fetch the latest Ubuntu AMI
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

# Retrieve VPC based on the tag Name
data "aws_vpc" "rocket-chat" {
  filter {
    name   = "tag:Name"
    values = ["rocket-chat-stag"]
  }
}

# Retrieve subnet based on the VPC and tag Name
data "aws_subnets" "public" {
  filter {
    name   = "tag:Environment"
    values = ["elb-dev"]
  }
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.rocket-chat.id]
  }
}

# Fetch the EC2 key pair used for the instances
data "aws_key_pair" "rocket_chat_key" {
  key_name = "elb-dev-key"
}

# Retrieve the security group by the group name and associated VPC
data "aws_security_groups" "rocket_chat_sgs" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.rocket-chat.id]
  }

  filter {
    name   = "tag:Name"
    values = ["rocket-chat-stag-frontend-sg"]
  }
}

data "aws_subnets" "subnets_in_vpc" {
  filter {
    name   = "vpc-id"
    values = ["vpc-0be22f1504b9eb68e"]
  }
}