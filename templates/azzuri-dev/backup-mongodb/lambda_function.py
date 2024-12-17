import os
import subprocess
import tempfile
from datetime import datetime
import boto3
import urllib.parse

def handler(event, context):
    # MongoDB connection details from environment variables
    mongodb_user = os.environ.get('MONGODB_USER', '')
    mongodb_pass = os.environ.get('MONGODB_PASS', '')
    mongodb_host = os.environ.get('MONGODB_HOST', '')
    mongodb_port = os.environ.get('MONGODB_PORT', '27017')
    mongodb_database = os.environ.get('MONGODB_DATABASE', 'rocketchat')

    # URL-encode user and pass to handle special characters
    mongodb_user = urllib.parse.quote_plus(mongodb_user) if mongodb_user else ""
    mongodb_pass = urllib.parse.quote_plus(mongodb_pass) if mongodb_pass else ""

    # Construct MongoDB URI
    if mongodb_user and mongodb_pass:
        mongodb_uri = f"mongodb://{mongodb_user}:{mongodb_pass}@{mongodb_host}:{mongodb_port}/{mongodb_database}"
    else:
        mongodb_uri = f"mongodb://{mongodb_host}:{mongodb_port}/{mongodb_database}"

    # S3 bucket name
    backup_bucket = os.environ.get('BACKUP_BUCKET', 'rochat-backup')

    # AWS credentials (from environment variables)
    aws_access_key_id = os.environ.get('AWS_ACCESS_KEY','')
    aws_secret_access_key = os.environ.get('AWS_SECRET_ACCESS_KEY','')
    aws_session_token = os.environ.get('AWS_SESSION_TOKEN','')

    if aws_access_key_id and aws_secret_access_key and aws_session_token:
        # Create an AWS session with the temporary credentials
        session = boto3.Session(
            aws_access_key_id=aws_access_key_id,
            aws_secret_access_key=aws_secret_access_key,
            aws_session_token=aws_session_token,
            region_name='us-east-1'
        )
    else:
        # If credentials are not provided, default to the environment's credentials
        session = boto3.Session(region_name='us-east-1')

    # Create S3 client using the session
    s3_client = session.client('s3')

    # Create temp directory for backup
    with tempfile.TemporaryDirectory() as tmpdir:
        # Generate backup filename with timestamp
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        backup_filename = f"{mongodb_database}_backup_{timestamp}.gz"
        backup_path = f"{tmpdir}/{backup_filename}"

        # Perform mongodump with connection string
        print(f"Using MongoDB URI: {mongodb_uri}")

        # Updated command as a single string
        mongodump_cmd = f"mongodump --uri='{mongodb_uri}' --gzip --archive={backup_path}"

        try:
            # Execute mongodump using shell=True for a consistent shell-like execution
            subprocess.run(mongodump_cmd, shell=True, check=True)

            # Upload to S3
            s3_client.upload_file(
                backup_path,
                backup_bucket,
                f'mongodb-backups/{backup_filename}'
            )

            return {
                'statusCode': 200,
                'body': f'Backup successful: {backup_filename}'
            }

        except subprocess.CalledProcessError as e:
            print(f"Backup failed: {e}")
            return {
                'statusCode': 500,
                'body': f'Backup failed: {str(e)}'
            }
        except Exception as e:
            print(f"Upload failed: {e}")
            return {
                'statusCode': 500,
                'body': f'Upload failed: {str(e)}'
            }
