# API Documentation for Image Generation

## Task 1a - Image Generation API

This API endpoint allows you to generate images based on a text prompt using a machine learning model.

### Endpoint URL
The endpoint to access Task 1a is available at the following URL:

[https://7ap2qx8a95.execute-api.eu-west-1.amazonaws.com/Prod/generate-image/](https://7ap2qx8a95.execute-api.eu-west-1.amazonaws.com/Prod/generate-image/)

### Request Format

To interact with the endpoint, send a **POST** request with header "Content-Type: application/json" and a JSON body in the following format:

```json
{
    "prompt": "your prompt goes here"
}
```
or with curl:

```
curl -X POST https://7ap2qx8a95.execute-api.eu-west-1.amazonaws.com/Prod/generate-image/ \
     -H "Content-Type: application/json" \
     -d '{"prompt": "Generate an image of a sunset over a mountain."}'
```

## Task 1b - GitHub Actions Workflow

Link to successfully deployed lambda function with GitHub actions:
https://github.com/ArianMathai/DevOpsExam2024/actions/runs/11800842361/job/32872716936


## Task 2a

sqs queue endpoint:
https://sqs.eu-west-1.amazonaws.com/244530008913/arma008_80_image_processing_queue

Request to sqs on this format using aws cli:

```
aws sqs send-message \
    --queue-url https://sqs.eu-west-1.amazonaws.com/244530008913/arma008_80_image_processing_queue \
    --message-body "Generate an image of a cute cat playing with yarn"
```

## Task 2b

Link to workflow on push to main branch:
https://github.com/ArianMathai/DevOpsExam2024/actions/runs/11818725716/job/32926959733

Link on push to non-main branch:
https://github.com/ArianMathai/DevOpsExam2024/actions/runs/11818933498/job/32927667182

## Task 3

### Docker Image Tagging Strategy

My tagging strategy for Docker images is designed to balance ease of use with robust version control. This approach ensures team members can always access the latest version while maintaining traceability and rollback capabilities.

#### Tags

- **latest**: Always points to the most recent version.
- **{git-sha}**: A unique tag based on the Git commit SHA.

#### Rationale

- **latest**: Provides quick access to the latest version, making it easy for the team to retrieve the most up-to-date image.
- **{git-sha}**: Enables traceability by linking the image back to the exact source code commit, offering the ability to roll back to specific versions if needed.

This strategy ensures a balance between accessing the newest version easily and maintaining control over version history.

### Container image name

```
arma008/sqs-image-client
```

### Sqs url

```
https://sqs.eu-west-1.amazonaws.com/244530008913/arma008_80_image_processing_queue
```

### Example usage
Add your own AWS credentials and add your own prompt to create generate image.
```
docker run -e AWS_ACCESS_KEY_ID=xxx -e AWS_SECRET_ACCESS_KEY=yyy -e SQS_QUEUE_URL=https://sqs.eu-west-1.amazonaws.com/244530008913/arma008_80_image_processing_queue arma008/sqs-image-client:latest "me on top of a pyramid" 
```

To check out other versions of the image, visit:
https://hub.docker.com/r/arma008/sqs-image-client/tags


