variable "name" {
  type = "string"
  description = "The name of the IAM Role (Human Readable)"
}

variable "assume_role_policy" {
  type = "string"
  description = "The path of the file that contains de sts assume policy used in the IAM Role"
}

variable "policies_files" {
  type = "map"
  description = "The policies files MAP to be attached to the role"
  default = {}
}

variable "policies_arn" {
  type = "map"
  description = "The policies ARN MAP to be attached to the role"
  default = {}
}
