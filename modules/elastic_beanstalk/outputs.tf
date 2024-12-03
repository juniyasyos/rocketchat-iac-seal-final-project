output "beanstalk_env_url" {
  description = "URL of the Elastic Beanstalk environment"
  value       = aws_elastic_beanstalk_environment.rocket_chat_env.endpoint_url
}