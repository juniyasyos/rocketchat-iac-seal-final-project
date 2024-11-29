# Local values for reuse throughout
locals {
  project_name          = "monitoring-project"
  environment           = "learning"
  region                = "us-east-1"
  key_name              = "monitoring"
  instances = {
    minikube-server = {
      ami           = data.aws_ami.ubuntu.id
      instance_type = "t3.large"
    }
  }
}
