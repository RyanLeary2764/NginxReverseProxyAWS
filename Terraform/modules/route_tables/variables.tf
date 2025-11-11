variable "vpc_id" {
  type        = string
  description = "VPC ID"
}


variable "subnet_id" {
  type        = string
  description = "List of subnet IDs"
}

variable "project" {
  type        = string
  description = "Project name"
}

variable "contact" {
  type        = string
  description = "Contact name"
}

variable "igw_id" {
  type        = string
  description = "Internet Gateway ID"
}
