#############################################################
# S3 bucket for AWS Config to record configuration history and snapshots
#############################################################
resource "aws_s3_bucket" "config_bucket" {
  bucket        = "config-bucket-${data.aws_caller_identity.current.account_id}-${data.aws_region.current.region}"
  force_destroy = true

  tags = {
    "Project" = var.project
  }
}

# Encrypting the bucket with AWS Managed SSE
resource "aws_s3_bucket_server_side_encryption_configuration" "config_bucket_encryption" {
  bucket = aws_s3_bucket.config_bucket.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}


# Attach Policy to bucket
resource "aws_s3_bucket_policy" "config_logging_policy" {
  bucket = aws_s3_bucket.config_bucket.id
  policy = data.aws_iam_policy_document.config_bucket_policy.json
}

# Define AWS S3 bucket policies SSL only and for the Config recorder
data "aws_iam_policy_document" "config_bucket_policy" {
  statement {
    sid = "AWSConfigBucketPermissionsCheck"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["config.amazonaws.com"]
    }

    actions = ["s3:GetBucketAcl"]

    resources = [
      aws_s3_bucket.config_bucket.arn
    ]

    condition {
      test = "StringEquals"
      variable = "aws:SourceAccount"
      values = [ data.aws_caller_identity.current.account_id ]
    }
  }

  statement {
    sid = "AWSConfigBucketDelivery"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["config.amazonaws.com"]
    }

    actions = ["s3:PutObject"]  # "s3:PutObject"]

    resources = [
      "${aws_s3_bucket.config_bucket.arn}/*"   #/AWSLogs/${data.aws_caller_identity.current.account_id}/config/*"
    ]

    condition {
      test = "StringEquals"
      variable = "aws:SourceAccount"
      values = [ data.aws_caller_identity.current.account_id ]
    }
  }

  statement {
    sid = "AWSConfigBucketSecureTransport"
    effect = "Deny"

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    actions = ["s3:*"]

    resources = [
      "${aws_s3_bucket.config_bucket.arn}",
      "${aws_s3_bucket.config_bucket.arn}/*"
    ]

    condition {
      test = "Bool"
      variable = "aws:SecureTransport"
      values = ["false"]
    }
  }
}
