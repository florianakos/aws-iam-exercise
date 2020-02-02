provider "aws" {
  region = var.region
  profile = "personal-aws"
}

variable "region" {
  type = string
  default = "eu-central-1" # Frankfurt
}

variable "secure_bucket_name" {
  type = string
  default = "flrnks-secure-bucket"
}

variable lambda_func_path {
  type = string
  default = "../src/lambda.zip"
}