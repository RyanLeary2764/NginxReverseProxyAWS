variable "instance_type" {
  type        = string
  description = "EC2 instance type"
}

variable "public_key" {
  type        = string
  description = "Public key for SSH access"
}

variable "subnet_id" {
  type        = string
  description = "Subnet ID"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "sg_id" {
  type        = string
  description = "Security Group ID"
}

variable "project" {
  type        = string
  description = "Project name"
}

variable "contact" {
  type        = string
  description = "Contact name"
}

variable "ami_id" {
  description = "AMI ID to use for EC2 instances"
  type        = string
  default     = "ami-0c02fb55956c7d316" # Example Amazon Linux 2 AMI in us-east-1
}

