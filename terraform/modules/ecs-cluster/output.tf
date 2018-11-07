output "sns_topic" {
  value = "${aws_sns_topic.topic.arn}"
}

output "sns_topic_subscription_id" {
  value = "${aws_sns_topic_subscription.topic_lambda.id}"
}

output "sns_topic_subscription_arn" {
  value = "${aws_sns_topic_subscription.topic_lambda.arn}"
}

output "lambda_function" {
  value = "${aws_lambda_function.lambda.arn}"
}

output "lc_id" {
  value = "${element(module.ecs-cluster-lc.launch_config_id, 0)}"
}

output "asg_id" {
  value = "${module.ecs-cluster-asg.asg_id}"
}

output "asg_pol_scale_cpu_up" {
  value = "${aws_autoscaling_policy.asg_pol_scale_cpu_up.arn}"
}

output "asg_pol_scale_cpu_down" {
  value = "${aws_autoscaling_policy.asg_pol_scale_cpu_down.arn}"
}

output "asg_pol_scale_mem_up" {
  value = "${aws_autoscaling_policy.asg_pol_scale_mem_up.arn}"
}

output "asg_pol_scale_mem_down" {
  value = "${aws_autoscaling_policy.asg_pol_scale_mem_down.arn}"
}

output "cw_metric_alarm_instance_memory_low" {
  value = "${aws_cloudwatch_metric_alarm.ecs_cluster_instances_memory_low.id}"
}

output "cw_metric_alarm_instance_memory_high" {
  value = "${aws_cloudwatch_metric_alarm.ecs_cluster_instances_memory_high.id}"
}

output "cw_metric_alarm_instance_cpu_low" {
  value = "${aws_cloudwatch_metric_alarm.ecs_cluster_instances_cpu_low.id}"
}

output "cw_metric_alarm_instance_cpu_high" {
  value = "${aws_cloudwatch_metric_alarm.ecs_cluster_instances_cpu_high.id}"
}

output "autoscaling_notification" {
  value = "${aws_autoscaling_notification.ecs-autoscaling-notification.notifications}"
}
