# Deploy Grafana on AWS Elastic Container Service (ECS) using Terraform

## 1. Installation Process

### 01.

Install Terraform & aws-cli on your Workstation

### 02.

Create a User in AWS IAM for your workstation with the Permissions found in the custom_policy.json file

### 03.

Create Access Key & Secret key for that IAM user and enter them in your workstation with the command:

```
aws configure
```

## 2. Infrastructure Setup (Terraform)

### 01. (Optional)

Create an s3 bucket for storing the Terraform State File

```
aws s3api create-bucket --bucket <your_bucket_name> --region <your_region> --acl private --create-bucket-configuration LocationConstraint=<your_region>
```

Uncomment the lines in terraform/s3.tf file, and edit the details to suit your created bucket 

```
vim terraform/s3.tf
```

### 02.

Navigate to the terraform directory and edit the variables.tf file to suit your enviorment (These components will be created by terraform):

```
vim variables.tf
```


### 03.

Run the following commands to initialize, and apply the terraform files

```
terraform init
terraform apply
```

### 04.

Browse to the Load Balancer DNS provided at the end of the terraform apply command (ALB-DNS-NAME). You should see The Grafana UI on port 3000.
