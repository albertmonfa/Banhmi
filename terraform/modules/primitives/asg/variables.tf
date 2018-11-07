variable "asg_name" {
  type = "string"
}

variable "tags" {
  description = "A map of tags to add to all resources"
  default     = {}
}

variable "subnets" {
  type = "list"
  description = "The subnets lists."
}

variable "lc_id" {
  type        = "string"
  description = "The launch configuration for the autoscaling group."
}

variable "default_cooldown" {
  type        = "string"
  description = "The amount of time, in seconds, after a scaling activity completes before another scaling activity can start."
  default     = ""
}

variable "desired_capacity" {
  type        = "string"
  description = "The number of Amazon EC2 instances that should be running in the group."
  default     = ""
}

variable "enabled_metrics" {
  type        = "list"
  description = "A list of metrics to collect. The allowed values are 'GroupMinSize', 'GroupMaxSize', 'GroupDesiredCapacity', 'GroupInServiceInstances', 'GroupPendingInstances', 'GroupStandbyInstances', 'GroupTerminatingInstances', 'GroupTotalInstances'."
  default     = []
}

variable "metrics_granularity" {
  type        = "string"
  default     = "1Minute"
}

variable "force_delete" {
  type        = "string"
  description = "Flag to allow deletion of the auto scaling group without waiting for all instances in the pool to terminate."
  default     = "false"
}

variable "hc_check_type" {
  type        = "string"
  description = "Type of health check performed by the auto scaling group. Valid values are 'ELB' or 'EC2'."
  default     = ""
}

variable "hc_grace_period" {
  type        = "string"
  description = "Time allowed after an instance comes into service before checking health."
  default     = ""
}

variable "max_size" {
  type        = "string"
  description = "Maximum number of instances allowed by the auto scaling group."
}

variable "min_size" {
  type        = "string"
  description = "Minimum number of instance to be maintained by the auto scaling group."
}

variable "placement_group" {
  type        = "string"
  description = "The name of the placement group into which you'll launch your instances, if any."
  default     = ""
}

variable "protect_from_scale_in" {
  type        = "string"
  description = "Allows setting instance protection. The autoscaling group will not select instances with this setting for terminination during scale in events."
  default     = ""
}

variable "suspended_processes" {
  type        = "list"
  description = "A list of processes to suspend for the AutoScaling Group. The allowed values are 'Launch', 'Terminate', 'HealthCheck', 'ReplaceUnhealthy', 'AZRebalance', 'AlarmNotification', 'ScheduledActions', 'AddToLoadBalancer'. Note that if you suspend either the 'Launch' or 'Terminate' process types, it can prevent your autoscaling group from functioning properly."
  default     = []
}

variable "termination_policies" {
  type        = "list"
  description = "A list of policies to decide how the instances in the auto scale group should be terminated. The allowed values are 'OldestInstance', 'NewestInstance', 'OldestLaunchConfiguration', 'ClosestToNextInstanceHour', 'Default'."
  default     = []
}

variable "wait_for_capacity_timeout" {
  type        = "string"
  description = "A maximum duration that Terraform should wait for ASG managed instances to become healthy before timing out."
  default     = ""
}

variable "load_balancers" {
  type        = "list"
  description = "List of load balancer names to associate with the auto scaling group."
  default     = []
}

variable "min_elb_capacity" {
  type        = "string"
  description = "Minimum number of healthy instances attached to the ELB that must be maintained during updates."
  default     = ""
}

variable "target_group_arns" {
  type        = "list"
  description = "A list of 'aws_alb_target_group' ARNs, for use with Application Load Balancing"
  default     = []
}

variable "wait_for_elb_capacity" {
  type        = "string"
  description = "Setting this will cause Terraform to wait for exactly this number of healthy instances in all attached load balancers on both create and update operations. (Takes precedence over 'min_elb_capacity' behavior.)"
  default     = ""
}
