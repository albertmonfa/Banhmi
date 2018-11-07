variable "role" {
  type = "string"
  description = "The role to be added to the policy"
}

variable "policies" {
  type = "map"
  description = "The policies MAP to be attached to the role"
}
