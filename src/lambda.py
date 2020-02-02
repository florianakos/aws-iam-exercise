import boto3
from botocore.exceptions import ClientError


def handler(event, context):

    sts_client = boto3.client('sts')
    print(f"\n === Checking IAM Identity ===\nARN: {sts_client.get_caller_identity()['Arn']}\n")
    s3_client = boto3.client('s3')

    print("=== Testing Read access to S3 file in bucket ===")
    try:
        print(s3_client.get_object(Bucket='flrnks-secure-bucket',
                                   Key='metrics.json')["Body"] \
              .read() \
              .decode('utf-8'))
    except ClientError as e:
        print(f"Error: {e.response['Error']['Code']}!")

    print("=== Testing Write access to S3 bucket ===")
    try:
        s3_client.put_object(Body=b'{ "data":"json" }',
                             Bucket='flrnks-secure-bucket',
                             Key='upload.json')
    except ClientError as e:
        print(f"Error: {e.response['Error']['Code']}!")

    response = sts_client.assume_role(
        RoleArn='arn:aws:iam::546454927816:role/S3-RW-Role',
        RoleSessionName='lambda',
    )

    session = boto3.Session(aws_access_key_id=response['Credentials']['AccessKeyId'],
                            aws_secret_access_key=response['Credentials']['SecretAccessKey'],
                            aws_session_token=response['Credentials']['SessionToken'])

    new_sts_client = session.client('sts')
    print(f"\n=== Assumed New IAM Identity ===\nARN: {new_sts_client.get_caller_identity()['Arn']}\n")

    print("=== Testing Write access to S3 bucket (using new role) ===")
    try:
        s3_client = session.client('s3')
        s3_client.put_object(Body=b'{ "data":"json" }',
                             Bucket='flrnks-secure-bucket',
                             Key='upload.json')
        print("... file was written successfully!\n")
    except ClientError as e:
        print(f"Error: {e.response['Error']['Code']}!")
