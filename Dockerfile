FROM apache/airflow:3.4.0

# Install libraries needed for S3 and Pandas S3 support
RUN pip install --no-cache-dir s3fs boto3
