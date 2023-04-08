import boto3
import csv
import os

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

# Set the local directory path and S3 object prefix
LOCAL_DIR_PATH = 'faker/output/'
S3_OBJECT_PREFIX = 'snowflake/import/'

# Get a list of all the files in the local directory
file_list = os.listdir(LOCAL_DIR_PATH)

# Loop through the list of files and upload each file to S3
for file_name in file_list:
    # Set the local file path and S3 object key
    local_file_path = os.path.join(LOCAL_DIR_PATH, file_name)
    s3_object_key = os.path.join(S3_OBJECT_PREFIX, file_name)

    # Upload the file to S3
    s3.upload_file(local_file_path, BUCKET_NAME, s3_object_key)

print('Files uploaded successfully!')