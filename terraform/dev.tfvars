# Variables for the development environment

# AWS region
variable "aws_region" {
  default = "eu-north-1"
}

# CIDR blocks
variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  default = "10.0.0.0/22"
}

variable "private_subnet_cidr" {
  default = "10.0.4.0/22"
}

# Availability Zone
variable "aws_availability_zone" {
  default = "eu-north-1a"
}

# Project-specific variables
variable "project_name" {
  default = "tracer"
}

variable "environment" {
  default = "dev"
}

variable "identify" {
  default = "tracer-dev"
}
