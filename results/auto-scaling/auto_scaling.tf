# Launch Template for nginx-server
resource "aws_launch_template" "nginx_launch_template" {
  name_prefix   = "${local.project_name}-nginx-launch-template"
  image_id      = data.aws_ami.ubuntu.id
  instance_type = var.instance_type_app
  key_name      = module.final-project-vpc.keypair

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.frontend.id]
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name        = "nginx-server"
      Project     = local.project_name
      Environment = local.environment
    }
  }

  user_data = base64encode(file("rocket-chat.sh"))
}

# Auto Scaling Group for nginx-server
resource "aws_autoscaling_group" "nginx_asg" {
  desired_capacity    = 2
  max_size            = 4
  min_size            = 1
  target_group_arns   = [aws_lb_target_group.main.arn]
  vpc_zone_identifier = module.final-project-vpc.public_subnets

  launch_template {
    id      = aws_launch_template.nginx_launch_template.id
    version = "$Latest"
  }

  lifecycle {
    create_before_destroy = true
  }

  tag {
    key                 = "Name"
    value               = "nginx-server"
    propagate_at_launch = true
  }

  tag {
    key                 = "Project"
    value               = local.project_name
    propagate_at_launch = true
  }

  tag {
    key                 = "Environment"
    value               = local.environment
    propagate_at_launch = true
  }
}

# Application Load Balancer
resource "aws_lb" "main" {
  name               = "${local.project_name}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = module.final-project-vpc.public_subnets

  tags = {
    Name        = "${local.project_name}-alb"
    Project     = local.project_name
    Environment = local.environment
  }
}

# Target Group for Load Balancer
resource "aws_lb_target_group" "main" {
  name     = "${local.project_name}-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.final-project-vpc.vpc_id

  health_check {
    enabled             = true
    path                = "/" # Adjust based on your application
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 5
    interval            = 30
  }
}

# Listener for Load Balancer
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }
}

# Auto Scaling Policies
resource "aws_autoscaling_policy" "scale_up" {
  name                   = "${local.project_name}-scale-up"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.nginx_asg.name
}

resource "aws_autoscaling_policy" "scale_down" {
  name                   = "${local.project_name}-scale-down"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.nginx_asg.name
}

# CloudWatch Alarms for Auto Scaling
resource "aws_cloudwatch_metric_alarm" "high_cpu" {
  alarm_name          = "${local.project_name}-high-cpu"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 70

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.nginx_asg.name
  }

  alarm_description = "This metric monitors EC2 CPU utilization"
  alarm_actions     = [aws_autoscaling_policy.scale_up.arn]
}

resource "aws_cloudwatch_metric_alarm" "low_cpu" {
  alarm_name          = "${local.project_name}-low-cpu"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 30

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.nginx_asg.name
  }

  alarm_description = "This metric monitors EC2 CPU utilization"
  alarm_actions     = [aws_autoscaling_policy.scale_down.arn]
}
