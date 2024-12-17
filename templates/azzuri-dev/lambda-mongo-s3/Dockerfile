FROM public.ecr.aws/lambda/python:3.9

# Minimal setup
RUN yum update -y && \
    yum install -y wget tar gzip

# Install mongodump manually
RUN wget https://fastdl.mongodb.org/tools/db/mongodb-database-tools-rhel70-x86_64-100.10.0.tgz && \
    tar -xzvf mongodb-database-tools-rhel70-x86_64-100.10.0.tgz && \
    mv mongodb-database-tools-rhel70-x86_64-100.10.0/bin/mongodump /usr/local/bin/ && \
    rm -rf mongodb-database-tools-rhel70-x86_64-100.10.0*

# Install Python dependencies
COPY requirements.txt .
RUN pip install  --no-cache-dir -r requirements.txt

# Copy lambda function
COPY lambda_function.py ${LAMBDA_TASK_ROOT}/

# Set the CMD to your handler
CMD ["lambda_function.handler"]
