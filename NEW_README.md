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
