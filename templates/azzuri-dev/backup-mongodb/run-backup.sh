#!/bin/bash

# Pull from ECR azzuri
sudo docker pull 211125298986.dkr.ecr.us-east-1.amazonaws.com/mongodb-backup:latest

# Collect environment variable inputs
echo "Enter the following environment variables:"

read -p "MONGODB_USER: " MONGODB_USER
read -p "MONGODB_PASS: " MONGODB_PASS
read -p "MONGODB_HOST: " MONGODB_HOST
read -p "MONGODB_PORT: " MONGODB_PORT
read -p "MONGODB_DATABASE: " MONGODB_DATABASE
read -p "BACKUP_BUCKET: " BACKUP_BUCKET
read -p "AWS_ACCESS_KEY: " AWS_ACCESS_KEY
read -p "AWS_SECRET_ACCESS_KEY: " AWS_SECRET_ACCESS_KEY
read -p "AWS_SESSION_TOKEN: " AWS_SESSION_TOKEN

echo "Jalankan: python -c 'import lambda_function; print(lambda_function.handler({}, {}))'"

docker run -it --entrypoint /bin/bash\
    -e MONGODB_USER="$MONGODB_USER" \
    -e MONGODB_PASS="$MONGODB_PASS" \
    -e MONGODB_HOST="$MONGODB_HOST" \
    -e MONGODB_PORT="$MONGODB_PORT" \
    -e MONGODB_DATABASE="$MONGODB_DATABASE" \
    -e BACKUP_BUCKET="$BACKUP_BUCKET" \
    -e AWS_ACCESS_KEY="$AWS_ACCESS_KEY" \
    -e AWS_SECRET_ACCESS_KEY="$AWS_SECRET_ACCESS_KEY" \
    -e AWS_SESSION_TOKEN="$AWS_SESSION_TOKEN" \
    211125298986.dkr.ecr.us-east-1.amazonaws.com/mongodb-backup
    
docker image rmi -f 211125298986.dkr.ecr.us-east-1.amazonaws.com/mongodb-backup