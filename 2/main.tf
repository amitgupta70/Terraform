provider "aws" {
  region     = "us-east-1"
}

resource "aws_instance" "First_Instance" {
    ami = "ami-0947d2ba12ee1ff75"
    instance_type = "t2.micro"

}

output "aws_instance" {
  value = "aws_instance.myec2.id"
}

resource "aws_eip" "lb" {
  vpc = true
}

  output "eip" {
      value = "aws_ip.lb.public_ip"
}

resource "aws_s3_bucket" "example" {
  bucket = "d37049s3"
  acl    = "private"

  tags = {
    Name        = "My Bucket"
    Environment = "Dev"
  }
}

data "aws_caller_identity" "current" {}

resource "aws_cloudtrail" "example" {
  name                          = "cldtrl"
  s3_bucket_name                = aws_s3_bucket.d37049.id
  s3_key_prefix                 = "prefix"
  is_multi_region_trail         = true
  include_global_service_events = true
}

resource "aws_s3_bucket" "d37049" {
  bucket = "d37049"

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AWSCloudTrailAclCheck",
            "Effect": "Allow",
            "Principal": {
              "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:GetBucketAcl",
            "Resource": "arn:aws:s3:::d37049"
        },
        {
            "Sid": "AWSCloudTrailWrite",
            "Effect": "Allow",
            "Principal": {
              "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:PutObject",
            "Resource": "arn:aws:s3:::d37049/prefix/AWSLogs/${data.aws_caller_identity.current.account_id}/*",
            "Condition": {
                "StringEquals": {
                    "s3:x-amz-acl": "bucket-owner-full-control"
                }
            }
        }
    ]
}
POLICY
}
