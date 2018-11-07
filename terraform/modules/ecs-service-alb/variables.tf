variable "project_name" {
  description = "Main name of the project"
}

variable "environment" {
  description = "Environment to deploy (Remember to checking the nlb_subnets and nlb_vpc variables)"
}

variable "alb_subnets" {
  description = "Subnets list for the Application Load Balancer"
  type        = "list"
}

variable "alb_sgs" {
  description = "Security Groups list for the Application Load Balancer"
  type        = "list"
}

variable "alb_internal" {
  description = "Flag for selection nlb scope: internal(true) or public(false)"
  type        = "string"
  default     = true
}

variable "alb_enable_deletion_protection" {
  type        = "string"
  description = "If true, deletion of the load balancer will be disabled via the AWS API. This will prevent Terraform from deleting the load balancer. Defaults to false."
  default     = false
}

variable "alb_idle_timeout" {
  type        = "string"
  description = "The time in seconds that the connection is allowed to be idle. Default: 20."
  default     = 20
}

variable "alb_listeners" {
  type        = "list"
  description = " List with the ports associated to the target group, usually one for non SSL conections and other for the encrypted traffic (80,443)"
}

variable "alb_listener_protocol" {
  type        = "string"
  description = "The protocol for connections from clients to the load balancer. Valid values are TCP, HTTP and HTTPS. Defaults to HTTP."
  default     = "HTTP"
}

variable "tg_vpc" {
  type        = "string"
  description = "The identifier of the VPC in which to create the target group."
}

variable "tg_target_type" {
  type        = "string"
  description = "The type of target that you must specify when registering targets with this target group. The possible values are instance (targets are specified by instance ID) or ip (targets are specified by IP address). The default is instance. Note that you can't specify targets for a target group using both instance IDs and IP addresses. If the target type is ip, specify IP addresses from the subnets of the virtual private cloud (VPC) for the target group, the RFC 1918 range (10.0.0.0/8, 172.16.0.0/12, and 192.168.0.0/16), and the RFC 6598 range (100.64.0.0/10). You can't specify publicly routable IP addresses."
  default = "instance"
}

variable "tg_deregistration_delay" {
  type        = "string"
  description = "The amount time for Elastic Load Balancing to wait before changing the state of a deregistering target from draining to unused. The range is 0-3600 seconds. The default value is 300 seconds."
  default     = 60
}

variable "tg_port" {
  type        = "string"
  description = "The port on which targets receive traffic, unless overridden when registering a specific target."
  default     = 80
}

variable "tg_path" {
  type        = "string"
  description = "The destination for the health check request. Default /."
  default     = "/"
}

variable "tg_matcher" {
  type        = "string"
  description = "The HTTP codes to use when checking for a successful response from a target. You can specify multiple values (for example, '200,202') or a range of values (for example, '200-299')."
  default     = "200-299,300-399,401"
}

variable "tg_hc_interval" {
  type        = "string"
  description = "The approximate amount of time, in seconds, between health checks of an individual target. Minimum value 5 seconds, Maximum value 300 seconds. Default 30 seconds."
  default     = 10
}

variable "tg_hc_healthy_threshold" {
  type        = "string"
  description = "The number of consecutive health checks successes required before considering an unhealthy target healthy. Defaults to 3."
  default     = 3
}

variable "tg_hc_unhealthy_threshold" {
  type        = "string"
  description = "The number of consecutive health check failures required before considering the target unhealthy. Defaults to 3."
  default     = 3
}

variable "task_role_arn" {
  type        = "string"
  description = "The ARN of IAM role that allows your Amazon ECS container task to make calls to other AWS services."
}

variable "ecs_container_definitions" {
  description = "The Task Definition skeleton, after define the container names you can't change the names defined, please contact with IT/OPS for best practices and common container names"
}

variable "ecs_container_name" {
  description = "The Name of the container in the ECS Task Definition (Default zin_default)"
  default     = "zin_default"
}

variable "ecs_container_port" {
  description = "The Port of the container in the ECS Task Definition (Default 80)"
  default     = 80
}

variable "ecs_cluster_name" {
  description = "ECS cluster name"
}

variable "ecs_service_role" {
  description = "ECS service IAM role"
}

variable "ecs_app_min_capacity" {
  description = "Minimum number of containers to run. (Default 3)"
  default = 3
}

variable "ecs_app_max_capacity" {
  description = "Maximum number of containers to run. (Default 10)"
  default = 10
}

variable "ecs_app_deployment_minimum_healthy_percent" {
  description = "The lower limit (as a percentage of the service's desiredCount) of the number of running tasks that must remain running and healthy in a service during a deployment. (Default 33)"
  default = 33
}

variable "ecs_app_deployment_maximum_percent" {
  description = "The upper limit (as a percentage of the service's desiredCount) of the number of running tasks that can be running in a service during a deployment. (Default 200)"
  default = 200
}

variable "ecs_service_autoscale" {
  description = "The IAM role used to autoscale the number of containers based on CW metrics"
}

variable "ecs_cpu_app_pol_scale_up_adjustment_type" {
  type        = "string"
  description = "Specifies whether the adjustment is an absolute number or a percentage of the current capacity. Valid values are ChangeInCapacity, ExactCapacity, and PercentChangeInCapacity. (Default ChangeInCapacity)"
  default     = "ChangeInCapacity"
}

variable "ecs_cpu_app_pol_scale_up_cooldown" {
  type        = "string"
  description = "The amount of time, in seconds, after a scaling activity completes and before the next scaling activity can start. (Default 120)"
  default     = 30
}

variable "ecs_cpu_app_pol_scale_up_metric_aggregation_type" {
  type        = "string"
  description = "The aggregation type for the policy's metrics. Valid values are 'Minimum', 'Maximum', and 'Average'. Without a value, AWS will treat the aggregation type as 'Average'. (Default Average)"
  default     = "Average"
}

variable "ecs_cpu_app_pol_scale_up_metric_interval_lower_bound" {
  type        = "string"
  description = "The lower bound for the difference between the alarm threshold and the CloudWatch metric. Without a value, AWS will treat this bound as infinity. The upper bound must be greater than the lower bound. (Default 0)"
  default     = 0
}

variable "ecs_cpu_app_pol_scale_up_scaling_adjustment" {
  type        = "string"
  description = "The number of members by which to scale, when the adjustment bounds are breached. A positive value scales up. A negative value scales down. (Default 1)"
  default     = 1
}

variable "ecs_cpu_app_pol_scale_down_adjustment_type" {
  type        = "string"
  description = "Specifies whether the adjustment is an absolute number or a percentage of the current capacity. Valid values are ChangeInCapacity, ExactCapacity, and PercentChangeInCapacity. (Default ChangeInCapacity)"
  default     = "ChangeInCapacity"
}

variable "ecs_cpu_app_pol_scale_down_cooldown" {
  type        = "string"
  description = "The amount of time, in seconds, after a scaling activity completes and before the next scaling activity can start. (Default 120)"
  default     = 30
}

variable "ecs_cpu_app_pol_scale_down_metric_aggregation_type" {
  type        = "string"
  description = "The aggregation type for the policy's metrics. Valid values are 'Minimum', 'Maximum', and 'Average'. Without a value, AWS will treat the aggregation type as 'Average'. (Default Average)"
  default     = "Average"
}

variable "ecs_cpu_app_pol_scale_down_metric_interval_upper_bound" {
  type        = "string"
  description = "The upper bound for the difference between the alarm threshold and the CloudWatch metric. Without a value, AWS will treat this bound as infinity. The upper bound must be greater than the lower bound. (Default 0)"
  default     = 0
}

variable "ecs_cpu_app_pol_scale_down_scaling_adjustment" {
  type        = "string"
  description = "The number of members by which to scale, when the adjustment bounds are breached. A positive value scales up. A negative value scales down. (Default 1)"
  default     = -1
}

variable "ecs_mem_app_pol_scale_up_adjustment_type" {
  type        = "string"
  description = "Specifies whether the adjustment is an absolute number or a percentage of the current capacity. Valid values are ChangeInCapacity, ExactCapacity, and PercentChangeInCapacity. (Default ChangeInCapacity)"
  default     = "ChangeInCapacity"
}

variable "ecs_mem_app_pol_scale_up_cooldown" {
  type        = "string"
  description = "The amount of time, in seconds, after a scaling activity completes and before the next scaling activity can start. (Default 120)"
  default     = 30
}

variable "ecs_mem_app_pol_scale_up_metric_aggregation_type" {
  type        = "string"
  description = "The aggregation type for the policy's metrics. Valid values are 'Minimum', 'Maximum', and 'Average'. Without a value, AWS will treat the aggregation type as 'Average'. (Default Average)"
  default     = "Average"
}

variable "ecs_mem_app_pol_scale_up_metric_interval_lower_bound" {
  type        = "string"
  description = "The upper bound for the difference between the alarm threshold and the CloudWatch metric. Without a value, AWS will treat this bound as infinity. The upper bound must be greater than the lower bound. (Default 0)"
  default     = 0
}

variable "ecs_mem_app_pol_scale_up_scaling_adjustment" {
  type        = "string"
  description = "The number of members by which to scale, when the adjustment bounds are breached. A positive value scales up. A negative value scales down. (Default 1)"
  default     = 1
}

variable "ecs_mem_app_pol_scale_down_adjustment_type" {
  type        = "string"
  description = "Specifies whether the adjustment is an absolute number or a percentage of the current capacity. Valid values are ChangeInCapacity, ExactCapacity, and PercentChangeInCapacity. (Default ChangeInCapacity)"
  default     = "ChangeInCapacity"
}

variable "ecs_mem_app_pol_scale_down_cooldown" {
  type        = "string"
  description = "The amount of time, in seconds, after a scaling activity completes and before the next scaling activity can start. (Default 120)"
  default     = 30
}

variable "ecs_mem_app_pol_scale_down_metric_aggregation_type" {
  type        = "string"
  description = "The aggregation type for the policy's metrics. Valid values are 'Minimum', 'Maximum', and 'Average'. Without a value, AWS will treat the aggregation type as 'Average'. (Default Average)"
  default     = "Average"
}

variable "ecs_mem_app_pol_scale_down_metric_interval_upper_bound" {
  type        = "string"
  description = "The upper bound for the difference between the alarm threshold and the CloudWatch metric. Without a value, AWS will treat this bound as infinity. The upper bound must be greater than the lower bound. (Default 0)"
  default     = 0
}

variable "ecs_mem_app_pol_scale_down_scaling_adjustment" {
  type        = "string"
  description = "The number of members by which to scale, when the adjustment bounds are breached. A positive value scales up. A negative value scales down. (Default 1)"
  default     = -1
}

variable "cloudwatch_metric_alarm_app_cpu_high_comparison_operator" {
  type        = "string"
  description = "The arithmetic operation to use when comparing the specified Statistic and Threshold. The specified Statistic value is used as the first operand. Either of the following is supported: GreaterThanOrEqualToThreshold, GreaterThanThreshold, LessThanThreshold, LessThanOrEqualToThreshold."
  default     = "GreaterThanOrEqualToThreshold"
}

variable "cloudwatch_metric_alarm_app_cpu_high_evaluation_periods" {
  type        = "string"
  description = "The number of periods over which data is compared to the specified threshold."
  default     = "1"
}

variable "cloudwatch_metric_alarm_app_cpu_high_period" {
  type        = "string"
  description = "The period in seconds over which the specified statistic is applied."
  default     = "60"
}

variable "cloudwatch_metric_alarm_app_cpu_high_statistic" {
  type        = "string"
  description = "The statistic to apply to the alarm's associated metric. Either of the following is supported: SampleCount, Average, Sum, Minimum, Maximum"
  default     = "Average"
}

variable "cloudwatch_metric_alarm_app_cpu_high_threshold" {
  type        = "string"
  description = "The value against which the specified statistic is compared."
  default     = "80"
}

variable "cloudwatch_metric_alarm_app_cpu_low_comparison_operator" {
  type        = "string"
  description = "The arithmetic operation to use when comparing the specified Statistic and Threshold. The specified Statistic value is used as the first operand. Either of the following is supported: GreaterThanOrEqualToThreshold, GreaterThanThreshold, LessThanThreshold, LessThanOrEqualToThreshold."
  default     = "LessThanThreshold"
}

variable "cloudwatch_metric_alarm_app_cpu_low_evaluation_periods" {
  type        = "string"
  description = "The number of periods over which data is compared to the specified threshold."
  default     = "1"
}

variable "cloudwatch_metric_alarm_app_cpu_low_period" {
  type        = "string"
  description = "The period in seconds over which the specified statistic is applied."
  default     = "60"
}

variable "cloudwatch_metric_alarm_app_cpu_low_statistic" {
  type        = "string"
  description = "The statistic to apply to the alarm's associated metric. Either of the following is supported: SampleCount, Average, Sum, Minimum, Maximum"
  default     = "Average"
}

variable "cloudwatch_metric_alarm_app_cpu_low_threshold" {
  type        = "string"
  description = "The value against which the specified statistic is compared"
  default     = "5"
}

variable "cloudwatch_metric_alarm_app_memory_high_comparison_operator" {
  type        = "string"
  description = "The arithmetic operation to use when comparing the specified Statistic and Threshold. The specified Statistic value is used as the first operand. Either of the following is supported: GreaterThanOrEqualToThreshold, GreaterThanThreshold, LessThanThreshold, LessThanOrEqualToThreshold."
  default     = "GreaterThanOrEqualToThreshold"
}

variable "cloudwatch_metric_alarm_app_memory_high_evaluation_periods" {
  type        = "string"
  description = "The number of periods over which data is compared to the specified threshold."
  default     = "1"
}

variable "cloudwatch_metric_alarm_app_memory_high_period" {
  type        = "string"
  description = "The period in seconds over which the specified statistic is applied."
  default     = "60"
}

variable "cloudwatch_metric_alarm_app_memory_high_statistic" {
  type        = "string"
  description = "The statistic to apply to the alarm's associated metric. Either of the following is supported: SampleCount, Average, Sum, Minimum, Maximum"
  default     = "Average"
}

variable "cloudwatch_metric_alarm_app_memory_high_threshold" {
  type        = "string"
  description = "The value against which the specified statistic is compared"
  default     = "80"
}

variable "cloudwatch_metric_alarm_app_memory_low_comparison_operator" {
  type        = "string"
  description = "The arithmetic operation to use when comparing the specified Statistic and Threshold. The specified Statistic value is used as the first operand. Either of the following is supported: GreaterThanOrEqualToThreshold, GreaterThanThreshold, LessThanThreshold, LessThanOrEqualToThreshold."
  default     = "LessThanThreshold"
}

variable "cloudwatch_metric_alarm_app_memory_low_evaluation_periods" {
  type        = "string"
  description = "The number of periods over which data is compared to the specified threshold."
  default     = "1"
}

variable "cloudwatch_metric_alarm_app_memory_low_period" {
  type        = "string"
  description = "The period in seconds over which the specified statistic is applied."
  default     = "60"
}

variable "cloudwatch_metric_alarm_app_memory_low_statistic" {
  type        = "string"
  description = "The statistic to apply to the alarm's associated metric. Either of the following is supported: SampleCount, Average, Sum, Minimum, Maximum"
  default     = "Average"
}

variable "cloudwatch_metric_alarm_app_memory_low_threshold" {
  type        = "string"
  description = "The value against which the specified statistic is compared"
  default     = "50"
}
