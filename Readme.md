# Serverless Telegram Bot (Task 10)

## 📌 Project Overview
This project deploys a fully serverless Telegram bot on AWS using Terraform for Infrastructure as Code (IaC). The bot is designed to demonstrate modular cloud architecture, integrating AWS Lambda, DynamoDB, and S3 with the external OpenWeatherMap API.

## 🏗 Architecture
The application follows a serverless event-driven architecture:
* Trigger: AWS API Gateway (HTTP API) receives Webhook events from Telegram.
* Compute: AWS Lambda (Python 3.9) processes requests securely.
* Database: DynamoDB (srh-task10-notes) persists user notes.
* Storage: S3 Bucket (srh-task10-files) manages file storage.
* External API: OpenWeatherMap API provides real-time weather data.
* Monitoring: CloudWatch Logs tracks execution and errors.

## 📂 Project Structure
The project is modularized to follow Terraform best practices, separating concerns into Compute, Database, and Storage resources.

```text
serverless-telegram-bot/
│
├── main.tf                 # Root configuration (Orchestrator)
├── terraform.tfvars        # Secrets (Excluded from Git)
│
├── modules/                # Reusable Infrastructure Modules
│   ├── compute/            # Lambda Function & IAM Roles
│   ├── database/           # DynamoDB Table Definition
│   └── storage/            # S3 Bucket Configuration
│
├── src/                    # Application Source Code
│   └── lambda_function.py  # Python Logic (The Bot)
│
└── screenshots/            # Evidence for Grading
```
🚀 Features (Grading Requirements)
External API Integration:

Command: /weather <city>

Functionality: Fetches real-time temperature and conditions from OpenWeatherMap.

Data Persistence:

Command: /save <note>

Functionality: Persists user input to DynamoDB.

Cloud Storage:

Command: /list

Functionality: Retrieves file metadata from the S3 bucket.

Security:

API Keys and Tokens are injected via environment variables (managed by terraform.tfvars), ensuring no secrets are hardcoded.

🛠 Prerequisites
Terraform installed.

AWS CLI configured with valid credentials.

Telegram Bot Token.

OpenWeatherMap API Key.

📦 Setup & Deployment
1. Configure Secrets
Create a terraform.tfvars file in the root directory. (Note: This file is excluded from version control for security).
```hcl
weather_api_key = "YOUR_OPENWEATHER_KEY"
telegram_token  = "YOUR_TELEGRAM_BOT_TOKEN"
project_id      = "task10"
```
2. Deploy Infrastructure
Initialize and apply the Terraform configuration:

```hcl
terraform init
terraform apply -auto-approve
```
3. Connect Webhook
After deployment, Terraform outputs the api_url. Register this with Telegram:
```hcl
curl -F "url=<YOUR_API_URL>" [https://api.telegram.org/bot](https://api.telegram.org/bot)<YOUR_TOKEN>/setWebhook
```
📸 Evidence & Verification
1. Live Bot Interaction
Demonstration of /weather, /save, and /list commands working in real-time.

2. Data Persistence (DynamoDB)
Verification that the /save command successfully wrote data ("Final Submission") to the database.

3. Operability (CloudWatch Logs)
System logs confirming successful Lambda execution and API integration.

🧹 Cleanup
To remove all resources and avoid AWS charges:
```hcl
terraform destroy -auto-approve
```
