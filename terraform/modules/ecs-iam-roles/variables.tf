provider "aws" {
  version = "~> 1.30.0"
}

variable "prefix-name" {
  type        = "string"
  description = "The prefix name used as base to compose the policies and role names"
}
