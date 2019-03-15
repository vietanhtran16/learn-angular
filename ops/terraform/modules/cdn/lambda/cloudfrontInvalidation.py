from __future__ import print_function
 
import boto3
import time
 
def lambda_handler(event, context):
    path = "/" + event["Records"][0]["s3"]["object"]["key"]
    bucket_name = event["Records"][0]["s3"]["bucket"]["name"]
   
    client = boto3.client('s3')
   
    client = boto3.client('cloudfront')
    invalidation = client.create_invalidation(DistributionId="E25BTDHKIISKRO",
        InvalidationBatch={
            'Paths': {
                'Quantity': 1,
                'Items': [path]
        },
        'CallerReference': str(time.time())
    })