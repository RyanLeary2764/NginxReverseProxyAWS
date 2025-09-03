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
