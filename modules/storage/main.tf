resource "aws_s3_bucket" "rocket_chat_bucket" {
  bucket = "${var.env}-rocket-chat-bucket"
  acl    = "private"

  versioning {
    enabled = true
  }

  tags = {
    Environment = var.env
    Project     = "RocketChat"
  }
}

resource "aws_s3_bucket_versioning" "rocket_chat_versioning" {
  bucket = aws_s3_bucket.rocket_chat_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_policy" "rocket_chat_policy" {
  bucket = aws_s3_bucket.rocket_chat_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.rocket_chat_bucket.arn}/*"
      }
    ]
  })
}