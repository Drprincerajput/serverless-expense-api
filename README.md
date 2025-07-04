# Serverless Expense API (Terraform + AWS Lambda + CI/CD)

This project is a fully serverless expense-tracking API built with:

- AWS Lambda (Python)
- API Gateway (REST)
- DynamoDB
- Terraform (Infrastructure as Code)
- GitHub Actions (CI/CD)

Everything is automated — from infrastructure provisioning to Lambda deployment and teardown.

---

## Features

- Deploys a REST API to AWS using Terraform
- Serverless Lambda function written in Python
- Stores expenses in DynamoDB
- Fully automated Lambda CI/CD pipeline
- Secure backend state stored in S3 with DynamoDB locking
- One-click destroy workflow (via GitHub Actions)

---

## Project Structure

```
serverless-expense-api/
├── bootstrap/              # Terraform code to create backend (S3 + DynamoDB)
├── infra/                  # Terraform code for AWS infra (API Gateway, Lambda, DynamoDB)
├── lambda/                 # Python code for AWS Lambda
├── .github/workflows/      # GitHub Actions for deploy + destroy
├── dev/terraform.tfvars    # Dev env vars (optional)
├── prod/terraform.tfvars   # Prod env vars (optional)
```

---

## API Endpoints

Base URL: `https://<api-id>.execute-api.<region>.amazonaws.com/dev`

- `POST /expenses` – Add an expense  
  Example:

  ```bash
  curl -X POST https://<api-url>/expenses \
    -H "Content-Type: application/json" \
    -d '{"amount": 500, "category": "Food"}'
  ```

- `GET /expenses` – Get all expenses

---

## Deployment Instructions

### 1. Bootstrap the Terraform Backend

```bash
cd bootstrap
terraform init
terraform apply -auto-approve
```

This creates:

- S3 bucket to store state
- DynamoDB table for state locking

### 2. Deploy the Infrastructure

```bash
cd infra
terraform init -backend-config=../bootstrap/backend.tf
terraform apply -auto-approve
```

This provisions:

- Lambda function
- DynamoDB table
- API Gateway

### 3. Test the API

Use `curl` or any REST client to test the endpoints.

---

## CI/CD with GitHub Actions

### Lambda Deployment Workflow

- Auto-triggers on changes to `lambda/` folder
- Zips code and updates the Lambda function

### Destroy Workflow

- Manually trigger from GitHub Actions tab
- Destroys all Terraform-managed AWS infrastructure

---

## Clean Up

To destroy infrastructure:

```bash
cd infra
terraform destroy -auto-approve
```

To destroy the backend (S3 + DynamoDB):

```bash
cd bootstrap
terraform destroy -auto-approve
```

If the S3 bucket is versioned, empty it manually or use `force_destroy = true`.

---

## Security

- AWS credentials are stored as GitHub secrets
- Terraform state is encrypted and versioned in S3
- DynamoDB table used for state locking to prevent race conditions

---

## Tech Stack

| Tool           | Purpose                          |
|----------------|----------------------------------|
| Terraform      | Infrastructure provisioning      |
| AWS Lambda     | API compute (Python handler)     |
| API Gateway    | REST endpoint                    |
| DynamoDB       | NoSQL storage                    |
| S3             | Terraform state backend          |
| GitHub Actions | CI/CD for Lambda + destroy       |
