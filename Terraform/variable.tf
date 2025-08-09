variable "instance_type" {
    default = "t2.micro"
    description = "type of ec2 instance"
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
  description = "Project name of tagging resources"
  default     = "recipe-app-api"
}

variable "contact" {
  description = "contact name for tagging resources"
  default     = "73.leary@gmail.com"
}