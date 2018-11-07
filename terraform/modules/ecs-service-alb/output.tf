output "ecs_service" {
  value = "${aws_ecs_service.app_ecs_service.id}"
}

output "alb_id" {
  value = "${aws_lb.app_alb.id}"
}

output "alb_arn" {
  value = "${aws_lb.app_alb.arn}"
}

output "alb_dns_name" {
  value = "${aws_lb.app_alb.dns_name}"
}

output "tg_id" {
  value = "${aws_lb_target_group.app_alb_tg.id}"
}

output "tg_arn" {
  value = "${aws_lb_target_group.app_alb_tg.arn}"
}

output "tg_arn_suffix" {
  value = "${aws_lb_target_group.app_alb_tg.arn_suffix}"
}

output "tg_name" {
  value = "${aws_lb_target_group.app_alb_tg.name}"
}

output "app_pol_cpu_scale_up" {
  value = "${aws_appautoscaling_policy.cpu_app_scale_up.arn}"
}

output "app_pol_cpu_scale_down" {
  value = "${aws_appautoscaling_policy.cpu_app_scale_down.arn}"
}

output "app_pol_mem_scale_up" {
  value = "${aws_appautoscaling_policy.mem_app_scale_up.arn}"
}

output "app_pol_mem_scale_down" {
  value = "${aws_appautoscaling_policy.mem_app_scale_down.arn}"
}

output "cw_metric_alarm_app_memory_low" {
  value = "${aws_cloudwatch_metric_alarm.app_service_memory_low.id}"
}

output "cw_metric_alarm_app_memory_high" {
  value = "${aws_cloudwatch_metric_alarm.app_service_memory_high.id}"
}

output "cw_metric_alarm_app_cpu_low" {
  value = "${aws_cloudwatch_metric_alarm.app_service_cpu_low.id}"
}

output "cw_metric_alarm_app_cpu_high" {
  value = "${aws_cloudwatch_metric_alarm.app_service_cpu_high.id}"
}
