variable "vpc_id" {}
variable "sg_name" {
  type = "string"
}

variable "sg_description" {
  default = "Security Group managed by Zinio IT/Ops Automation Framework"
}

variable "inbound_rules" {
  type = "map"
}

variable "outbound_rules" {
  type = "map"
}

variable "tags" {
  type = "map"
}
