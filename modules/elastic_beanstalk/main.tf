# Define the Elastic Beanstalk Application
resource "aws_elastic_beanstalk_application" "rocket_chat" {
  name        = "${var.env}-rocket-chat"
  description = "Elastic Beanstalk application for Rocket.Chat in ${var.env} environment"
}

# Define the Elastic Beanstalk Environment
resource "aws_elastic_beanstalk_environment" "rocket_chat_env" {
  name                = "${var.env}-rocket-chat-env"
  application         = aws_elastic_beanstalk_application.rocket_chat.name
  solution_stack_name = "64bit Amazon Linux 2 v3.4.11 running Docker"

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "InstanceType"
    value     = var.instance_type
  }

  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MinSize"
    value     = "1"
  }

  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MaxSize"
    value     = "3"
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "MONGO_URL"
    value     = var.mongodb_url
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "ROOT_URL"
    value     = var.root_url
  }

  tags = {
    Environment = var.env
    Project     = "RocketChat"
  }
}