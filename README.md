# backend_cloud_resume_challenge_2025

You are currently on the Backend repo of my iteration of the Cloud Resume Challenge from Forrest Brazeal, a fully serverless, automated resume website using AWS. 
Go here for the [Frontend](https://github.com/frenzymilk/frontend_cloud_resume_challenge_2025).

![Architecture Diagram](https://github.com/frenzymilk/backend_cloud_resume_challenge_2025/blob/main/architecture/architecture_diagram.png)

Here’s what I delivered:

✅ Multi-account AWS environment built using AWS Organizations
- Root actions restricted
- Accounts prevented from leaving the org
- Billing alarms at multiple tiers with SNS email alerts

✅ Serverless resume website
- Static site in S3 served securely via CloudFront- API Gateway + Lambda + DynamoDB for a dynamic visitor counter

✅ Automation + Infrastructure as Code
- Full deployment via Terraform
- GitHub Actions CI/CD automatically syncs changed files to S3
- CloudFront cache invalidation triggered only for updated assets

✅ Security and IAM as a first-class requirement
- Fine-grained IAM policies for least-privilege access
- Clear separation between users, roles, and service permissions
- HTTPS enforced and no public backend access
