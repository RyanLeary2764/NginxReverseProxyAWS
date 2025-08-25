###############################################################
# Create IAM user and policies for Continuous Deploy (CD) account
###############################################################

# IAM user
resource "aws_iam_user" "cd" {
  name = "level-one-user"
}

# IAM access key for GitHub Actions
resource "aws_iam_access_key" "cd" {
  user = aws_iam_user.cd.name
}

#########################################################
# Policy for Terraform backend (S3 + DynamoDB)
#########################################################
data "aws_iam_policy_document" "tf_backend" {
  statement {
    effect    = "Allow"
    actions   = ["s3:ListBucket"]
    resources = ["arn:aws:s3:::${var.tf_state_bucket}"]
  }
  statement {
    effect  = "Allow"
    actions = ["s3:GetObject", "s3:PutObject", "s3:DeleteObject"]
    resources = [
      "arn:aws:s3:::${var.tf_state_bucket}/tf-state-setup",
    ]
  }
  statement {
    effect  = "Allow"
    actions = [
      "dynamodb:DescribeTable",
      "dynamodb:GetItem",
      "dynamodb:PutItem",
      "dynamodb:DeleteItem"
    ]
    resources = ["arn:aws:dynamodb:*:*:table/${var.tf_state_lock_table}"]
  }
}

resource "aws_iam_policy" "tf_backend" {
  name        = "${aws_iam_user.cd.name}-tf-s3-dynamodb"
  description = "Allow user to use S3 and DynamoDB for TF backend resources"
  policy      = data.aws_iam_policy_document.tf_backend.json
}

resource "aws_iam_user_policy_attachment" "tf_backend" {
  user       = aws_iam_user.cd.name
  policy_arn = aws_iam_policy.tf_backend.arn
}

#########################################################
# Policy for EC2 read access (for Ansible dynamic inventory)
#########################################################
data "aws_iam_policy_document" "ec2_read" {
  statement {
    effect = "Allow"
    actions = [
      "ec2:DescribeInstances",
      "ec2:DescribeTags"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "ec2_read" {
  name        = "${aws_iam_user.cd.name}-ec2-read"
  description = "Allow user to read EC2 instances and tags"
  policy      = data.aws_iam_policy_document.ec2_read.json
}

resource "aws_iam_user_policy_attachment" "ec2_read" {
  user       = aws_iam_user.cd.name
  policy_arn = aws_iam_policy.ec2_read.arn
}
