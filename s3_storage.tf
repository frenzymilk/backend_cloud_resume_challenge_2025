/*create S3 storage bucket for the resume*/
resource "aws_s3_bucket" "domain" {
  bucket = var.domain_name
}
/*associated bucket policy*/
resource "aws_s3_bucket_policy" "allow_access_to_cloudfront_distribution" {
  bucket = aws_s3_bucket.domain.bucket
  policy = data.aws_iam_policy_document.allow_access_to_cloudfront_distribution.json
}
data "aws_iam_policy_document" "allow_access_to_cloudfront_distribution" {
  statement {
    sid    = "AllowCloudFrontServicePrincipal"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    actions = [
      "s3:GetObject"
    ]

    resources = [
      "${aws_s3_bucket.domain.arn}/*"
    ]

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [aws_cloudfront_distribution.s3_distribution.arn]
    }
  }
}

/* create S3 storage for redirection to www.pernelle-mensah.com*/
resource "aws_s3_bucket" "subdomain" {
  bucket = "www.${var.domain_name}"
}
