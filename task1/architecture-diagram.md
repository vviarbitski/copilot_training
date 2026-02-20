# Architecture Diagram

```mermaid
flowchart LR
  Dev[Developer] -->|git push| Repo[GitHub Repo]
  Repo --> CI[CI/CD: GitHub Actions]

  subgraph AWS[AWS Account / Region]
    subgraph VPC[VPC]
      subgraph Public[Public Subnets (2 AZs)]
        ALB[Application Load Balancer]
        NAT[NAT Gateways (2)]
      end
      subgraph Private[Private Subnets (2 AZs)]
        ASG[EC2 Auto Scaling Group]
        CW[CloudWatch Logs/Alarms]
        SSM[SSM Parameter Store]
      end
      IGW[Internet Gateway]
      ALB --> ASG
      ASG --> CW
      ASG --> SSM
      NAT --> IGW
    end

    ECR[ECR Container Registry]
    S3[S3 Artifact/State Bucket]
    KMS[KMS Key]
    EVB[EventBridge Scheduler]
    L[Lambda: Scale to zero]
  end

  CI -->|build/push| ECR
  CI -->|deploy| ASG
  EVB --> L --> ASG
  KMS --> S3
  KMS --> SSM
```
