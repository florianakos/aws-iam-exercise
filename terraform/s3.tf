data "aws_iam_policy_document" "s3_ro_access_policy_document" {
  statement {
    effect    = "Allow"
    actions = [
      "s3:GetObject",
      "s3:ListBucket",
    ]
    resources = [
      "arn:aws:s3:::${var.secure_bucket_name}",
      "arn:aws:s3:::${var.secure_bucket_name}/*"
    ]
  }
}

resource "aws_iam_policy" "s3_ro_access_policy" {
  name   = "S3-ReadOnly-Access"
  policy = data.aws_iam_policy_document.s3_ro_access_policy_document.json
}

resource "aws_iam_role_policy_attachment" "Allow_S3_ReadOnly_Access" {
  role       = aws_iam_role.aws_custom_role_for_lambda.name
  policy_arn = aws_iam_policy.s3_ro_access_policy.arn
}

data "aws_iam_policy_document" "s3_rw_access_policy_document" {
  statement {
    effect    = "Allow"
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:ListBucket",
    ]
    resources = [
      "arn:aws:s3:::${var.secure_bucket_name}",
      "arn:aws:s3:::${var.secure_bucket_name}/*"
    ]
  }
}

resource "aws_iam_policy" "s3_rw_access_policy" {
  name   = "S3-ReadWrite-Access"
  policy = data.aws_iam_policy_document.s3_rw_access_policy_document.json
}

resource "aws_iam_role_policy_attachment" "Allow_S3_ReadWrite_Access" {
  role       = aws_iam_role.aws_s3_readwrite_role.name
  policy_arn = aws_iam_policy.s3_rw_access_policy.arn
}

data "aws_iam_policy_document" "s3_rw_assume_allow" {
  statement {
    actions = [ "sts:AssumeRole", ]
    principals {
      type = "AWS"
      identifiers = [ aws_iam_role.aws_custom_role_for_lambda.arn, ]
    }
  }
}

resource "aws_iam_role" "aws_s3_readwrite_role" {
  name               = "S3-RW-Role"
  description        = "Role to allow full RW to bucket"
  assume_role_policy = data.aws_iam_policy_document.s3_rw_assume_allow.json
}

resource "aws_s3_bucket" "ddg_aws_bucket" {
  bucket = var.secure_bucket_name
  force_destroy = "true"
}