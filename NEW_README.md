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

## Task 1b - Github Actions Workflow

Link to successfully deployed lambda function with github actions:
https://github.com/ArianMathai/DevOpsExam2024/actions/runs/11799509488/job/32868179528
