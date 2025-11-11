variable "instance_type" {
  default     = "t2.micro"
  description = "Type of EC2 instance"
}

variable "tf_state_bucket" {
  description = "Name of the S3 bucket in AWS for storing TF state"
  default     = "level-one-bucket"
}

variable "tf_state_lock_table" {
  description = "Name of the DynamoDB table for TF state locking"
  default     = "level-one-lock-table"
}

variable "project" {
  description = "Project name for tagging resources"
  default     = "recipe-app-api"
}

variable "contact" {
  description = "Contact name/email for tagging resources"
  default     = "73.leary@gmail.com"
}

variable "public_key" {
  type        = string
  description = "SSH public key for EC2 access"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  validation {
    condition     = can(cidrhost(var.vpc_cidr_block, 0))
    error_message = "Must be a valid CIDR block."
  }
}

variable "public_subnet_cidr" {
  description = "CIDR block for the subnet"
  type        = string
  validation {
    condition     = can(cidrhost(var.subnet_cidr_block, 0))
    error_message = "Must be a valid CIDR block."
  }
}

variable "availability_zone" {
  description = "AWS availability zone for subnet and EC2"
  type        = string
}
