# OIDC for git actions24
data "tls_certificate" "eks248" {
  url = "https://token.actions.githubusercontent.com"
}

resource "aws_iam_openid_connect_provider" "github" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.eks24.certificates[0].sha1_fingerprint]
  url             = "https://token.actions.githubusercontent.com"
}

# Role to be assumed with a federated principal
data "aws_iam_policy_document" "git_aws_oidc" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.github.url, "https://", "")}:aud"
      values   = ["sts.amazonaws.com"]
    }

    condition {
      test     = "StringLike"
      variable = "${replace(aws_iam_openid_connect_provider.github.url, "https://", "")}:sub"
      values   = ["repo:Andreadote/*:*"] # put your repo there
    }


    principals {
      identifiers = [aws_iam_openid_connect_provider.github.arn]
      type        = "Federated"
    }
  }
}

resource "aws_iam_role" "tesla_action_policy" {
  assume_role_policy = data.aws_iam_policy_document.git_aws_oidc.json
  name               = "git-actions-oidc"
}

resource "aws_iam_policy" "tesla_action_policy" {
  name = "git-actions-oidc"

  policy = jsonencode({
    Statement = [{
      Action   = ["*"]
      Effect   = "Allow"
      Resource = "*"
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "git_actions_oidc_attachment" {
  role       = aws_iam_role.tesla_action_policy.name
  policy_arn = aws_iam_policy.tesla_action_policy.arn
}

output "git_actions_oidc" {
  value = aws_iam_role.tesla_action_policy.arn
}

provider "aws" {
  region = "us-west-2"
}