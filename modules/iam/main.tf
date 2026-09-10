# IAM role for EC2 — allows the web server to access S3 without hardcoded credentials
resource "aws_iam_role" "ec2" {
  name        = "${var.environment}-ec2-role"
  description = "Role assumed by the EC2 web server to access S3 app files"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Environment = var.environment
  }
}

# Policy — EC2 can read and write app files in S3
resource "aws_iam_policy" "ec2_s3" {
  name        = "${var.environment}-ec2-s3-policy"
  description = "Allows EC2 to read and write app files in S3"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:ListBucket"
        ]
        Resource = [
          var.s3_bucket_arn,
          "${var.s3_bucket_arn}/*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ec2_s3" {
  role       = aws_iam_role.ec2.name
  policy_arn = aws_iam_policy.ec2_s3.arn
}

# Instance profile — the wrapper that lets EC2 use an IAM role
resource "aws_iam_instance_profile" "ec2" {
  name = "${var.environment}-ec2-instance-profile"
  role = aws_iam_role.ec2.name
}
