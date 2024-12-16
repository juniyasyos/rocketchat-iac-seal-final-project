# Specify the provider
provider "aws" {
  region = "us-east-1" # Adjust if needed
}

# Create S3 bucket
resource "aws_s3_bucket" "backup_bucket" {
  bucket = "rochat-backup"

  # Enable versioning for backups
  versioning {
    enabled = true
  }

  # Enable encryption
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = {
    Name        = "Rochat Backup Bucket"
    Environment = "Production"
  }
}

# IAM role for Lambda function
resource "aws_iam_role" "lambda_exec_role" {
  name = "rochat-backup-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = { Service = "lambda.amazonaws.com" }
      }
    ]
  })
}

# IAM policy for S3 access
resource "aws_iam_policy" "s3_access_policy" {
  name = "rochat-backup-s3-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = ["s3:PutObject", "s3:GetObject", "s3:ListBucket"],
        Effect = "Allow",
        Resource = [
          aws_s3_bucket.backup_bucket.arn,
          "${aws_s3_bucket.backup_bucket.arn}/*"
        ]
      }
    ]
  })
}

# Attach policy to the Lambda role
resource "aws_iam_role_policy_attachment" "lambda_s3_access" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = aws_iam_policy.s3_access_policy.arn
}

# Create Lambda function with container image
resource "aws_lambda_function" "rochat_backup" {
  function_name = "rochat-backup"
  package_type  = "Image"
  image_uri     = "211125298986.dkr.ecr.us-east-1.amazonaws.com/mongodb-backup:latest"
  role          = aws_iam_role.lambda_exec_role.arn

  environment {
    variables = {
      BACKUP_BUCKET    = "rochat-backup"
      MONGODB_USER     = "username-env-mongodb"
      MONGODB_PASS     = "password-env-mongodb"
      MONGODB_HOST     = "172.31.86.132" # sesuaikan dengan ip private server mongodb
      MONGODB_PORT     = "27017"
      MONGODB_DATABASE = "rocketchat"
    }
  }

  tags = {
    Name        = "Rochat Backup Lambda"
    Environment = "Production"
  }
}

# Grant Lambda permission to write logs to CloudWatch
resource "aws_lambda_permission" "allow_cloudwatch" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.rochat_backup.function_name
  principal     = "logs.amazonaws.com"
}
