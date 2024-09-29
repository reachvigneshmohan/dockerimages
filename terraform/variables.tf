
# variables.tf
# the Terraform command will not fail if you don't provide a variables.tf file, as long as the required variable values are provided from other sources like .tfvars files, environment variables, or command-line arguments.
# If you don't have a variables.tf file and also do not provide values for the variables via .tfvars files, environment variables, or command-line flags, Terraform will fail, prompting for the missing variables.

variable "location" {
  description = "Location for the resources"
  type        = string
}

variable "environment" {
  description = "The environment (dev, qa, prod)"
  type        = string
}

variable "environment" {
  description = "The environment (dev, qa, prod)"
  type        = string
}
