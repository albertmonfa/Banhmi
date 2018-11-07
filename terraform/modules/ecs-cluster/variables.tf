variable "ecs_cluster_name" {
  type        = "string"
  description = "The ECS Cluster name"
}

variable "ecs_cluster_sns_topic_name" {
  type        = "string"
  description = "The SNS Topic name used to scaling adjustment in a ECS Cluster"
}

variable "sns_lambda_iam_role" {
  type        = "string"
  description = "The IAM Role used by Autoscaling Lambda function to read the SNS topic"
}

variable "lambda_iam_role" {
  type        = "string"
  description = "The role used to execute Lambda functions"
}

variable "lambda_timeout" {
  type        = "string"
  description = "The max execution time for the Lambda function"
  default     = 300
}

variable "lc_name" {
  type = "string"
  description = "The Launch Configuration name"
}

variable "lc_associate_public_ip_address" {
  type        = "string"
  description = "Flag for associating public IP addresses with instances managed by the auto scaling group"
  default     = false
}

variable "lc_ebs_optimized" {
  type        = "string"
  description = "Flag to enable EBS optimization."
  default     = false
}

variable "lc_enable_monitoring" {
  type        = "string"
  description = "Flag to enable detailed monitoring."
  default     = false
}

variable "lc_iam_instance_profile" {
  type        = "string"
  description = "IAM instance profile to associate with the launch configuration."
  default     = ""
}

variable "lc_ami" {
  type        = "string"
  description = "Amazon Machine Image (AMI) to associate with the launch configuration."
}

variable "lc_instance_type" {
  type        = "string"
  description = "EC2 instance type to associate with the launch configuration."
  default     = "t2.small"
}

variable "lc_security_groups" {
  type        = "list"
  description = "Security Groups associated to the EC2 instances for the Launch configuration"
}

variable "lc_key_name" {
  type        = "string"
  description = "SSH key pair to associate with the launch configuration."
}

variable "lc_placement_tenancy" {
  type        = "string"
  description = "The tenancy of the instance. Valid values are 'default' or 'dedicated'."
  default     = "default"
}

variable "lc_spot_price" {
  type        = "string"
  description = "The price to use for reserving spot instances."
  default     = ""
}

variable "lc_ebs_vol_del_on_term" {
  type        = "string"
  description = "Whether the volume should be destroyed on instance termination."
  default     = true
}

variable "lc_ebs_vol_device_name" {
  type        = "string"
  description = "The name of the device to mount."
  default     = ""
}

variable "lc_ebs_vol_encrypted" {
  type        = "string"
  description = "Whether the volume should be encrypted or not. Do not use this option if you are using 'snapshot_id' as the encrypted flag will be determined by the snapshot."
  default     = ""
}

variable "lc_ebs_vol_snapshot_id" {
  type        = "string"
  description = "The Snapshot ID to mount."
  default     = ""
}

variable "lc_ebs_vol_iops" {
  type        = "string"
  description = "The amount of provisioned IOPS"
  default     = ""
}

variable "lc_ebs_vol_size" {
  type        = "string"
  description = "The size of the volume in gigabytes."
  default     = ""
}

variable "lc_ebs_vol_type" {
  type        = "string"
  description = "The type of volume. Valid values are 'standard', 'gp2' and 'io1'."
  default     = "gp2"
}

variable "lc_root_vol_del_on_term" {
  type        = "string"
  description = "Whether the volume should be destroyed on instance termination."
  default     = true
}

variable "lc_root_vol_iops" {
  type        = "string"
  description = "The amount of provisioned IOPS"
  default     = "300"
}

variable "lc_root_vol_size" {
  type        = "string"
  description = "The size of the volume in gigabytes."
  default     = "5"
}

variable "lc_root_vol_type" {
  type        = "string"
  description = "The type of volume. Valid values are 'standard', 'gp2' and 'io1'."
  default     = "gp2"
}

variable "lc_template_file" {
  type        = "string"
  description = "The default ECS user-data for our clusters"
  default     = "ecs-simple-user-data"
}

variable "asg_name" {
  type        = "string"
  description = "The name for the ecs-cluster Autoscaling Group"
}

variable "asg_subnets" {
  type        = "list"
  description = "The subnets lists used in the ASG"
}

variable "asg_default_cooldown" {
  type        = "string"
  description = "The amount of time, in seconds, after a scaling activity completes before another scaling activity can start."
  default     = 120
}

variable "asg_desired_capacity" {
  type        = "string"
  description = "The number of Amazon EC2 instances that should be running in the group."
  default     = 3
}

variable "asg_enabled_metrics" {
  type        = "list"
  description = "A list of metrics to collect. The allowed values are 'GroupMinSize', 'GroupMaxSize', 'GroupDesiredCapacity', 'GroupInServiceInstances', 'GroupPendingInstances', 'GroupStandbyInstances', 'GroupTerminatingInstances', 'GroupTotalInstances'."
  default     = []
}

variable "asg_metrics_granularity" {
  type        = "string"
  default     = "1Minute"
}

variable "asg_force_delete" {
  type        = "string"
  description = "Flag to allow deletion of the auto scaling group without waiting for all instances in the pool to terminate."
  default     = "false"
}

variable "asg_hc_check_type" {
  type        = "string"
  description = "Type of health check performed by the auto scaling group. Valid values are 'ELB' or 'EC2'."
  default     = ""
}

variable "asg_hc_grace_period" {
  type        = "string"
  description = "Time allowed after an instance comes into service before checking health."
  default     = ""
}

variable "asg_max_size" {
  type        = "string"
  description = "Maximum number of instances allowed by the auto scaling group."
  default     = 10
}

variable "asg_min_size" {
  type        = "string"
  description = "Minimum number of instance to be maintained by the auto scaling group."
  default     = 3
}

variable "asg_placement_group" {
  type        = "string"
  description = "The name of the placement group into which you'll launch your instances, if any."
  default     = ""
}

variable "asg_protect_from_scale_in" {
  type        = "string"
  description = "Allows setting instance protection. The autoscaling group will not select instances with this setting for terminination during scale in events."
  default     = ""
}

variable "asg_suspended_processes" {
  type        = "list"
  description = "A list of processes to suspend for the AutoScaling Group. The allowed values are 'Launch', 'Terminate', 'HealthCheck', 'ReplaceUnhealthy', 'AZRebalance', 'AlarmNotification', 'ScheduledActions', 'AddToLoadBalancer'. Note that if you suspend either the 'Launch' or 'Terminate' process types, it can prevent your autoscaling group from functioning properly."
  default     = []
}

variable "asg_termination_policies" {
  type        = "list"
  description = "A list of policies to decide how the instances in the auto scale group should be terminated. The allowed values are 'OldestInstance', 'NewestInstance', 'OldestLaunchConfiguration', 'ClosestToNextInstanceHour', 'Default'."
  default     = ["OldestInstance"]
}

variable "asg_wait_for_capacity_timeout" {
  type        = "string"
  description = "A maximum duration that Terraform should wait for ASG managed instances to become healthy before timing out."
  default     = "10m"
}

variable "asg_pol_scale_up_scaling_adjustment" {
  type        = "string"
  description = "The number of instances by which to scale. adjustment_type determines the interpretation of this number (e.g., as an absolute number or as a percentage of the existing Auto Scaling group size). A positive increment adds to the current capacity and a negative value removes from the current capacity."
  default     = "2"
}

variable "asg_pol_scale_up_cooldown" {
  type        = "string"
  description = "The amount of time, in seconds, after a scaling activity completes and before the next scaling activity can start"
  default     = "30"
}

variable "asg_pol_scale_down_scaling_adjustment" {
  type        = "string"
  description = "The number of instances by which to scale. adjustment_type determines the interpretation of this number (e.g., as an absolute number or as a percentage of the existing Auto Scaling group size). A positive increment adds to the current capacity and a negative value removes from the current capacity."
  default     = "-1"
}

variable "asg_pol_scale_down_cooldown" {
  type        = "string"
  description = "The amount of time, in seconds, after a scaling activity completes and before the next scaling activity can start"
  default     = "30"
}

variable "cloudwatch_metric_alarm_ec2_cpu_high_comparison_operator" {
  type        = "string"
  description = "The arithmetic operation to use when comparing the specified Statistic and Threshold. The specified Statistic value is used as the first operand. Either of the following is supported: GreaterThanOrEqualToThreshold, GreaterThanThreshold, LessThanThreshold, LessThanOrEqualToThreshold."
  default     = "GreaterThanOrEqualToThreshold"
}

variable "cloudwatch_metric_alarm_ec2_cpu_high_evaluation_periods" {
  type        = "string"
  description = "The number of periods over which data is compared to the specified threshold."
  default     = "1"
}

variable "cloudwatch_metric_alarm_ec2_cpu_high_period" {
  type        = "string"
  description = "The period in seconds over which the specified statistic is applied."
  default     = "60"
}

variable "cloudwatch_metric_alarm_ec2_cpu_high_statistic" {
  type        = "string"
  description = "The statistic to apply to the alarm's associated metric. Either of the following is supported: SampleCount, Average, Sum, Minimum, Maximum"
  default     = "Average"
}

variable "cloudwatch_metric_alarm_ec2_cpu_high_threshold" {
  type        = "string"
  description = "The value against which the specified statistic is compared."
  default     = "70"
}

variable "cloudwatch_metric_alarm_ec2_cpu_low_comparison_operator" {
  type        = "string"
  description = "The arithmetic operation to use when comparing the specified Statistic and Threshold. The specified Statistic value is used as the first operand. Either of the following is supported: GreaterThanOrEqualToThreshold, GreaterThanThreshold, LessThanThreshold, LessThanOrEqualToThreshold."
  default     = "LessThanThreshold"
}

variable "cloudwatch_metric_alarm_ec2_cpu_low_evaluation_periods" {
  type        = "string"
  description = "The number of periods over which data is compared to the specified threshold."
  default     = "1"
}

variable "cloudwatch_metric_alarm_ec2_cpu_low_period" {
  type        = "string"
  description = "The period in seconds over which the specified statistic is applied."
  default     = "60"
}

variable "cloudwatch_metric_alarm_ec2_cpu_low_statistic" {
  type        = "string"
  description = "The statistic to apply to the alarm's associated metric. Either of the following is supported: SampleCount, Average, Sum, Minimum, Maximum"
  default     = "Average"
}

variable "cloudwatch_metric_alarm_ec2_cpu_low_threshold" {
  type        = "string"
  description = "The value against which the specified statistic is compared."
  default     = "5"
}

variable "cloudwatch_metric_alarm_ec2_memory_high_comparison_operator" {
  type        = "string"
  description = "The arithmetic operation to use when comparing the specified Statistic and Threshold. The specified Statistic value is used as the first operand. Either of the following is supported: GreaterThanOrEqualToThreshold, GreaterThanThreshold, LessThanThreshold, LessThanOrEqualToThreshold."
  default     = "GreaterThanOrEqualToThreshold"
}

variable "cloudwatch_metric_alarm_ec2_memory_high_evaluation_periods" {
  type        = "string"
  description = "The number of periods over which data is compared to the specified threshold."
  default     = "1"
}

variable "cloudwatch_metric_alarm_ec2_memory_high_period" {
  type        = "string"
  description = "The period in seconds over which the specified statistic is applied."
  default     = "60"
}

variable "cloudwatch_metric_alarm_ec2_memory_high_statistic" {
  type        = "string"
  description = "The statistic to apply to the alarm's associated metric. Either of the following is supported: SampleCount, Average, Sum, Minimum, Maximum"
  default     = "Average"
}

variable "cloudwatch_metric_alarm_ec2_memory_high_threshold" {
  type        = "string"
  description = "The value against which the specified statistic is compared."
  default     = "80"
}

variable "cloudwatch_metric_alarm_ec2_memory_low_comparison_operator" {
  type        = "string"
  description = "The arithmetic operation to use when comparing the specified Statistic and Threshold. The specified Statistic value is used as the first operand. Either of the following is supported: GreaterThanOrEqualToThreshold, GreaterThanThreshold, LessThanThreshold, LessThanOrEqualToThreshold."
  default     = "LessThanThreshold"
}

variable "cloudwatch_metric_alarm_ec2_memory_low_evaluation_periods" {
  type        = "string"
  description = "The number of periods over which data is compared to the specified threshold."
  default     = "1"
}

variable "cloudwatch_metric_alarm_ec2_memory_low_period" {
  type        = "string"
  description = "The period in seconds over which the specified statistic is applied."
  default     = "60"
}

variable "cloudwatch_metric_alarm_ec2_memory_low_statistic" {
  type        = "string"
  description = "The statistic to apply to the alarm's associated metric. Either of the following is supported: SampleCount, Average, Sum, Minimum, Maximum"
  default     = "Average"
}

variable "cloudwatch_metric_alarm_ec2_memory_low_threshold" {
  type        = "string"
  description = "The value against which the specified statistic is compared."
  default     = "50"
}
