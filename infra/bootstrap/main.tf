resource "aws_s3_bucket" "terraform_state" {
  bucket = var.bucket_name

  tags = {
    Name        = "Terraform State Bucket"
    Environment = "Bootstrap"
    ManagedBy   = "Terraform"
  }
}

# Enable versioning to recover previous state versions
resource "aws_s3_bucket_versioning" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Enable server-side encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Block all public access
resource "aws_s3_bucket_public_access_block" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

data "aws_caller_identity" "current" {}

data "aws_partition" "current" {}

# 1. Trust GitHub as an OIDC identity provider
resource "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"

  client_id_list = [
    "sts.amazonaws.com"
  ]
}

# 2. Allow only the specified GitHub repository and branch
data "aws_iam_policy_document" "github_trust" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type = "Federated"
      identifiers = [
        aws_iam_openid_connect_provider.github.arn
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:sub"
      values = [
        "repo:${var.github_repository}:ref:refs/heads/${var.github_branch}"
      ]
    }
  }
}

resource "aws_iam_role" "github_actions" {
  name               = "taskboard-github-actions-role"
  assume_role_policy = data.aws_iam_policy_document.github_trust.json
}

# 3. Permissions for pushing backend images to ECR
data "aws_iam_policy_document" "github_permissions" {
  # ECR authentication requires Resource = "*"
  statement {
    sid       = "ECRAuthentication"
    effect    = "Allow"
    actions   = ["ecr:GetAuthorizationToken"]
    resources = ["*"]
  }

  # Push images only to the specified backend repository
  statement {
    sid    = "PushBackendImage"
    effect = "Allow"

    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload",
      "ecr:PutImage"
    ]

    resources = [
      "arn:${data.aws_partition.current.partition}:ecr:eu-north-1:${data.aws_caller_identity.current.account_id}:repository/${var.backend_ecr_repository_name}"
    ]
  }

  # Upload and sync frontend files in the specified bucket
  statement {
    sid       = "ListFrontendBucket"
    effect    = "Allow"
    actions   = ["s3:ListBucket"]
    resources = [
      "arn:${data.aws_partition.current.partition}:s3:::${var.frontend_bucket_name}"
    ]
  }

  statement {
    sid    = "ManageFrontendFiles"
    effect = "Allow"

    actions = [
      "s3:PutObject",
      "s3:DeleteObject"
    ]

    resources = [
      "arn:${data.aws_partition.current.partition}:s3:::${var.frontend_bucket_name}/*"
    ]
  }
}

resource "aws_iam_policy" "github_permissions" {
  name   = "taskboard-github-actions-policy"
  policy = data.aws_iam_policy_document.github_permissions.json
}

resource "aws_iam_role_policy_attachment" "github_permissions" {
  role       = aws_iam_role.github_actions.name
  policy_arn = aws_iam_policy.github_permissions.arn
}