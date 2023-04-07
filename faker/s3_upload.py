import boto3
import csv

with open('..\Common\s_python_s3_poc_accessKeys.csv', 'r') as csvfile:
    csvreader = csv.reader(csvfile)
    for row in csvreader:
        # Set your AWS access keys
        ACCESS_KEY = row[1]
        SECRET_KEY = row[2]

# Set the name of the S3 bucket
BUCKET_NAME = 'sf-bucket-290'

# Create an S3 client
s3 = boto3.client('s3', aws_access_key_id=ACCESS_KEY, aws_secret_access_key=SECRET_KEY)

# Upload the file to S3

# Set the local file path and S3 object key
LOCAL_FILE_PATH = 'faker/output/application_log.json'
S3_OBJECT_KEY = 'snowflake/import/application_log.json'
s3.upload_file(LOCAL_FILE_PATH, BUCKET_NAME, S3_OBJECT_KEY)

# Set the local file path and S3 object key
LOCAL_FILE_PATH = 'faker/output/firewall_log.json'
S3_OBJECT_KEY = 'snowflake/import/firewall_log.json'
s3.upload_file(LOCAL_FILE_PATH, BUCKET_NAME, S3_OBJECT_KEY)

# Set the local file path and S3 object key
LOCAL_FILE_PATH = 'faker/output/fake_nested_data.json'
S3_OBJECT_KEY = 'snowflake/import/fake_nested_data.json'
s3.upload_file(LOCAL_FILE_PATH, BUCKET_NAME, S3_OBJECT_KEY)

print('File uploaded successfully!')