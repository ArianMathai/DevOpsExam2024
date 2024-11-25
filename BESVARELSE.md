# Documentation for DevOps exam 2024

# Task 1a - Image Generation API

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

# Task 1b - GitHub Actions Workflow

Link to successfully deployed lambda function with GitHub actions:
https://github.com/ArianMathai/DevOpsExam2024/actions/runs/11800842361/job/32872716936


# Task 2a

sqs queue endpoint:
https://sqs.eu-west-1.amazonaws.com/244530008913/arma008_80_image_processing_queue

Request to sqs on this format using aws cli:

```
aws sqs send-message \
    --queue-url https://sqs.eu-west-1.amazonaws.com/244530008913/arma008_80_image_processing_queue \
    --message-body "Generate an image of a cute cat playing with yarn"
```

I have also added a Dead Letter Queue (DLQ) to serve as a safety net for my main queue. It captures messages that fail to be processed by the main queue after three attempts. This setup helps ensure that problematic messages do not block the main queue, allowing for smoother processing and easier troubleshooting of errors.
# Task 2b

Link to workflow on push to main branch:
https://github.com/ArianMathai/DevOpsExam2024/actions/runs/11818725716/job/32926959733

Link on push to non-main branch:
https://github.com/ArianMathai/DevOpsExam2024/actions/runs/11818933498/job/32927667182

# Task 3

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
Add your own AWS credentials and add your own prompt to generate image.
```
docker run -e AWS_ACCESS_KEY_ID=xxx -e AWS_SECRET_ACCESS_KEY=yyy -e SQS_QUEUE_URL=https://sqs.eu-west-1.amazonaws.com/244530008913/arma008_80_image_processing_queue arma008/sqs-image-client:latest "me on top of a pyramid" 
```

To check out other versions of the docker-image, visit:
https://hub.docker.com/r/arma008/sqs-image-client/tags


# Task 4

I have added an alarm for the ApproximateAgeOfOldestMessage sqs metric. 
To add you own email for notifications you can add the email address as a variable when running terraform apply.

# Task 5

## Discussion of the Implications of Using Serverless Architecture vs. Microservices Architecture in Light of DevOps Principles

---

## 1. Automation and Continuous Delivery (CI/CD)

### Serverless Architecture
- **Advantages**:
    - Functions can be developed, tested, and deployed individually, enabling more frequent and faster deployments.
    - CI/CD pipelines can be optimized for small, independent functions, allowing automation to focus on specific components.
    - Deployment is managed by the cloud provider, reducing infrastructure management complexity.
- **Disadvantages**:
    - The increased number of functions and components requires more pipelines, which may lead to fragmentation and maintenance complexity.
    - Testing and debugging across functions become more challenging due to distributed dependencies.

### Microservices Architecture
- **Advantages**:
    - Services are typically larger, resulting in fewer CI/CD pipelines compared to serverless architecture.
    - Building, testing, and deploying can include the entire service logic, offering better overall control.
- **Disadvantages**:
    - Requires more extensive infrastructure management, which can slow deployments and increase CI/CD setup complexity.
    - Scaling deployments across multiple services may require orchestration tools like Kubernetes, adding overhead.

---

## 2. Observability

### Serverless Architecture
- **Advantages**:
    - Tools like AWS CloudWatch provide deep insights into function-level metrics and logging.
    - Automatic logging of function invocations, response times, and errors.
- **Disadvantages**:
    - Troubleshooting is more challenging as functions are smaller and tightly coupled through asynchronous message queues.
    - "Cold starts" and transient errors can be difficult to detect and trace.
    - Increased complexity with more functions, requiring consistent standards for logging and traceability.

### Microservices Architecture
- **Advantages**:
    - Unified tools for logging, tracing, and monitoring (e.g., Prometheus, ELK stack) provide better visibility across services.
    - Logging and error handling are simpler because microservices are often more self-contained and less reliant on third-party integrations.
- **Disadvantages**:
    - More manual configuration and maintenance are required to ensure effective logging and observability.
    - Distributed systems can still face challenges with debugging and traceability, especially with many services.

---

## 3. Scalability and Cost Control

### Serverless Architecture
- **Advantages**:
    - Automatically scales based on demand, reducing the need for pre-allocating resources.
    - The "pay-as-you-go" pricing model ensures costs are directly tied to actual usage.
    - Minimizes the risk of over- or under-provisioning resources.
- **Disadvantages**:
    - Costs can become unpredictable during sudden traffic spikes.
    - Cold starts can result in higher latency for some function invocations.
    - Limited control over the underlying infrastructure may restrict optimization.

### Microservices Architecture
- **Advantages**:
    - Greater control over resource allocation and optimization, potentially more cost-effective for applications with steady load.
    - Services can be configured to meet specific resource requirements, providing predictable costs.
- **Disadvantages**:
    - Requires more effort to design systems that scale effectively.
    - Fixed cost structure even under low loads, as the infrastructure often needs to run continuously.

---

## 4. Ownership and Responsibility

### Serverless Architecture
- **Advantages**:
    - The cloud provider assumes responsibility for infrastructure, including availability, scaling, and security.
    - Development teams can focus on application logic rather than infrastructure.
- **Disadvantages**:
    - Limited control can lead to challenges in optimizing performance and costs.
    - Increased complexity in managing the lifecycle of many small functions.

### Microservices Architecture
- **Advantages**:
    - Full control over application performance and infrastructure offers greater flexibility.
    - Clear ownership of services promotes accountability within the DevOps team.
- **Disadvantages**:
    - Greater responsibility for handling operations, security, and infrastructure.
    - Requires dedicated resources to ensure performance and reliability.

---

## Conclusion

| DevOps Aspect       | Serverless Architecture              | Microservices Architecture           |
|----------------------|--------------------------------------|---------------------------------------|
| **CI/CD**           | Frequent deployments but complex pipeline management | Fewer pipelines but slower deployments |
| **Observability**   | Granular insights but challenges with distribution and cold starts | Holistic visibility but more manual setup |
| **Scalability and Cost** | Dynamic scaling, unpredictable costs | Predictable costs but less flexibility |
| **Ownership**       | Lower operational burden but increased complexity | Full control but higher administrative overhead |

The choice between architectures should be based on the application’s requirements, the team’s skills, and the desired level of control and flexibility.