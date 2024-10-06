# dev.tfvars
# variables.tf: Declares variables that will be used in your Terraform configurations. This file is generic and doesn't contain any specific values for environments like dev or prod.
# dev.tfvars: Contains values for the dev environment that will override the declared variables in variables.tf. You can create similar .tfvars files for other environments (e.g., prod.tfvars, staging.tfvars).

# AWS region
aws_region = "eu-north-1"

# CIDR blocks
vpc_cidr = "10.0.0.0/16"
public_subnet_cidr = "10.0.0.0/22"
private_subnet_cidr = "10.0.4.0/22"

# Availability Zone
aws_availability_zone = "eu-north-1a"

# Project-specific variables
project_name = "tracer"
environment = "dev"
identify = "tracer-dev"
