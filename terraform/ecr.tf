provider "aws" {
  region = "eu-north-1"  # Replace with your desired AWS region
}

# List of ECR repositories to be created
variable "ecr_repositories" {
  type = list(string)
  default =   default = ['client-gateway-service,device-gateway-server,rawdata-parsing-service,data-normalization-service,device-command-center-service,auth-service,device-management-service,asset-management-service,driver-management-service,notification-service,alert-management-service,geofencing-service,analytics-service,billing-service'] # Add all your services here
}

# Create multiple ECR repositories
resource "aws_ecr_repository" "repositories" {
  for_each = toset(var.ecr_repositories)

  name = each.value
  image_tag_mutability = "IMMUTABLE"  # Ensures that tags cannot be overwritten
}
