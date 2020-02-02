# AWS IAM Exercise

Simple project which I used to practice AWS IAM concepts using Python / Boto3. Using the Terraform files, one can create the necessary IAM roles and an AWS Lambda funciton that can function using these roles.

```
 === Checking IAM Identity ===
ARN: arn:aws:sts::??????????:assumed-role/Base-Lambda-Custom-Role/lambda

=== Checking Read access to S3 file ===
{
	"blablabla": true
	"xyz": 52679913
}

=== Checking Write access to S3 file ===
Error: AccessDenied!

=== Assuming New IAM Identity ===
ARN: arn:aws:sts::??????????:assumed-role/S3-RW-Role/lambda

=== Checking Write access to S3 bucket ===
... with success!

```