variable "application_name" {  }
variable "environment_name" {  }

variable "ami" {
  description = "AMI id to launch, must be in the region specified by the region variable"
}

variable "key_name" {
    description = "SSH key name in your AWS account for AWS instances."
}

variable "region" {
    default = "us-east-1"
    description = "The region of AWS"
}

variable "availability_zones" {
    description = "Comma separated list of EC2 availability zones to launch instances, must be within region"
}

variable "subnet_ids" {
    description = "Comma separated list of subnet ids, must match availability zones"
}

variable "private_subnet_ids" {
    description = "Comma separated list of private subnet ids, to put app instances in"
}

variable "instance_type" {
    default = "m1.small"
    description = "Name of the AWS instance type"
}

variable "min_size" {
    default = "1"
    description = "Minimum number of instances to run in the group"
}

variable "max_size" {
    default = "5"
    description = "Maximum number of instances to run in the group"
}

variable "desired_capacity" {
    default = "1"
    description = "Desired number of instances to run in the group"
}

variable "iam_instance_profile" {
    description = "The IAM Instance Profile (e.g. right side of Name=AmazonECSContainerInstanceRole)"
}

variable "user-data-path" {
    description = "What to run once the AMI boots"
}

variable "instance_port" {
    description = "The http port the application listens on"
}

variable "health_check_url" {
    description = "The url to hit to check if the application is working"
}

variable "min_size" {
    description = "The min number of instances to run"
    default = 1
}

variable "max_size" {
    description = "The max number of instances to run"
    default = 5
}

variable "desired_size" {
    description = "The desired number of instances to run"
    default = 2
}

variable "vpc_id" {
}

