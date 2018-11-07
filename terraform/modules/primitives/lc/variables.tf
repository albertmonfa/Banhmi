variable "ami" {
  type        = "string"
  description = "Amazon Machine Image (AMI) to associate with the launch configuration."
}

variable "ebs_vol_del_on_term" {
  type        = "string"
  description = "Whether the volume should be destroyed on instance termination."
  default     = "true"
}

variable "ebs_vol_device_name" {
  type        = "string"
  description = "The name of the device to mount."
  default     = ""
}

variable "ebs_vol_encrypted" {
  type        = "string"
  description = "Whether the volume should be encrypted or not. Do not use this option if you are using 'snapshot_id' as the encrypted flag will be determined by the snapshot."
  default     = ""
}

variable "ebs_vol_snapshot_id" {
  type        = "string"
  description = "The Snapshot ID to mount."
  default     = ""
}

variable "ebs_vol_iops" {
  type        = "string"
  description = "The amount of provisioned IOPS"
  default     = "300"
}

variable "ebs_vol_size" {
  type        = "string"
  description = "The size of the volume in gigabytes."
  default     = ""
}

variable "ebs_vol_type" {
  type        = "string"
  description = "The type of volume. Valid values are 'standard', 'gp2' and 'io1'."
  default     = "gp2"
}

variable "iam_instance_profile" {
  type        = "string"
  description = "IAM instance profile to associate with the launch configuration."
  default     = ""
}

variable "instance_type" {
  type        = "string"
  description = "EC2 instance type to associate with the launch configuration."
  default     = "t2.small"
}

variable "key_name" {
  type        = "string"
  description = "SSH key pair to associate with the launch configuration."
  default     = ""
}

variable "root_vol_del_on_term" {
  type        = "string"
  description = "Whether the volume should be destroyed on instance termination."
  default     = "true"
}

variable "root_vol_iops" {
  type        = "string"
  description = "The amount of provisioned IOPS"
  default     = "300"
}

variable "root_vol_size" {
  type        = "string"
  description = "The size of the volume in gigabytes."
  default     = ""
}

variable "root_vol_type" {
  type        = "string"
  description = "The type of volume. Valid values are 'standard', 'gp2' and 'io1'."
  default     = "gp2"
}

variable "security_groups" {
  type        = "list"
  description = "A list of associated security group IDs"
  default     = []
}

variable "spot_price" {
  type        = "string"
  description = "The price to use for reserving spot instances."
  default     = ""
}

variable "lc_name" {
  type = "string"
}

variable "template_file" {
  type = "string"
}

variable "template_vars" {
  type = "map"
}

variable "associate_public_ip_address" {
  type        = "string"
  description = "Flag for associating public IP addresses with instances managed by the auto scaling group."
  default     = ""
}

variable "enable_monitoring" {
  type        = "string"
  description = "Flag to enable detailed monitoring."
  default     = ""
}

variable "ebs_optimized" {
  type        = "string"
  description = "Flag to enable EBS optimization."
  default     = false
}

variable "placement_tenancy" {
  type = "string"
  description = "The tenancy of the instance. Valid values are 'default' or 'dedicated'."
  default = "default"
}
