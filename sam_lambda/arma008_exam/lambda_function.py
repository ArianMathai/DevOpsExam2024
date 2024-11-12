import base64
import os

import boto3
import json
import random
import traceback

# Set up AWS clients
bedrock_client = boto3.client("bedrock-runtime", region_name="us-east-1")
s3_client = boto3.client("s3")


# Define model ID and S3 bucket name
model_id = "amazon.titan-image-generator-v1"
bucket_name = os.environ['BUCKET_NAME']
candidate_number = "80"

# bucket_name = "pgr301-couch-explorers"

def lambda_handler(event, context):
    try:
        # Get 'prompt' from the body of the POST request
        body = json.loads(event["body"])
        prompt = body.get("prompt", "Default prompt if none provided")

        # Generate seed for unique file name
        seed = random.randint(0, 2147483647)
        s3_image_path = f"{candidate_number}/generated_images/titan_{seed}.png"

        # Set up the model request
        native_request = {
            "taskType": "TEXT_IMAGE",
            "textToImageParams": {"text": prompt},
            "imageGenerationConfig": {
                "numberOfImages": 1,
                "quality": "standard",
                "cfgScale": 8.0,
                "height": 1024,
                "width": 1024,
                "seed": seed,
            }
        }

        # Call the model with the request
        response = bedrock_client.invoke_model(modelId=model_id, body=json.dumps(native_request))
        model_response = json.loads(response["body"].read())

        # Extract and decode Base64 image data
        base64_image_data = model_response["images"][0]
        image_data = base64.b64decode(base64_image_data)

        # Upload the decoded image to S3
        s3_client.put_object(Bucket=bucket_name, Key=s3_image_path, Body=image_data)

        # Return a JSON response with the image URL
        response_body = {
            "message": "Image generated successfully!",
            "image_url": f"https://{bucket_name}.s3.amazonaws.com/{s3_image_path}"
        }

        return {
            "statusCode": 200,
            "body": json.dumps(response_body)
        }

    except KeyError as e:
        # Handle missing key in event or response
        error_message = f"KeyError: Missing key {str(e)}"
        print(error_message)
        return {
            "statusCode": 400,
            "body": json.dumps({"message": error_message})
        }

    except boto3.exceptions.S3UploadFailedError as e:
        # Handle S3 upload failure
        error_message = f"S3UploadFailedError: {str(e)}"
        print(error_message)
        return {
            "statusCode": 500,
            "body": json.dumps({"message": "Failed to upload image to S3", "error": error_message})
        }

    except boto3.exceptions.Boto3Error as e:
        # Handle general AWS service exceptions
        error_message = f"Boto3Error: {str(e)}"
        print(error_message)
        return {
            "statusCode": 500,
            "body": json.dumps({"message": "AWS service error", "error": error_message})
        }

    except Exception as e:
        # Catch any other exceptions and log the stack trace
        error_message = f"Unexpected error: {str(e)}"
        traceback_str = traceback.format_exc()
        print(f"{error_message}\n{traceback_str}")
        return {
            "statusCode": 500,
            "body": json.dumps({"message": "Internal server error", "error": error_message, "details": traceback_str})
        }
