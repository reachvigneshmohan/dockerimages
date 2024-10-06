
# variables.tf
# AWS region
variable "aws_region" {
  description = "The AWS region to deploy resources in."
  type        = string
}

# CIDR blocks
variable "vpc_cidr" {
  description = "The CIDR block for the VPC."
  type        = string
}

variable "public_subnet_cidr" {
  description = "The CIDR block for the public subnet."
  type        = string
}

variable "private_subnet_cidr" {
  description = "The CIDR block for the private subnet."
  type        = string
}

# Availability Zone
variable "aws_availability_zone" {
  description = "The AWS availability zone."
  type        = string
}

# Project-specific variables
variable "project_name" {
  description = "The name of the project."
  type        = string
}

variable "environment" {
  description = "The environment (e.g., dev, staging, production)."
  type        = string
}

variable "identify" {
  description = "A unique identifier for tagging purposes."
  type        = string
}
