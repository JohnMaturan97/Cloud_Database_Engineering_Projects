variable "Access_Key_ID" {
  type = string
}

variable "Secret_Access_Key" {
  type = string
}

variable "private_subnets" {
  type = map(any)
  default = {
    a = "10.0.4.0/24"
    b = "10.0.5.0/24"
    c = "10.0.6.0/24"
  }
}

variable "subnets" {
  description = "Default values for public subnets."
  type        = map(any)
  default = {
    a = "10.0.1.0/24"
    b = "10.0.2.0/24"
    c = "10.0.3.0/24"
  }
}

variable "tags" {
  description = "Default tags to apply to all resources."
  type        = map(any)
  default = {
    Key1 = "development",
    Key2 = "slvr-workspace"
  }
}

variable "vpc_cidr" {
  description = "The network addressing for the default VPC."
  type        = string
  default     = "10.0.0.0/16"
}