import boto3
import csv

with open('..\Common\s_python_s3_poc_accessKeys.csv', 'r') as csvfile:
    csvreader = csv.reader(csvfile)
    for row in csvreader:
        # Set your AWS access keys
        ACCESS_KEY = row[0]
        SECRET_KEY = row[1]

# Set the name of the S3 bucket
BUCKET_NAME = 'sf-bucket-290'

# Set the local file path and S3 object key
LOCAL_FILE_PATH = 'faker/output/application_log.json'
S3_OBJECT_KEY = 'snowflake/import/application_log.json'

# Create an S3 client
s3 = boto3.client('s3', aws_access_key_id=ACCESS_KEY, aws_secret_access_key=SECRET_KEY)

# Upload the file to S3
# s3.upload_file(LOCAL_FILE_PATH, BUCKET_NAME, S3_OBJECT_KEY)

print('File uploaded successfully!')