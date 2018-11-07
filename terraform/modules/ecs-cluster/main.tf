resource "aws_sns_topic" "topic" {
  name = "${var.ecs_cluster_sns_topic_name}"
}

resource "aws_sns_topic_subscription" "topic_lambda" {
  topic_arn = "${aws_sns_topic.topic.arn}"
  protocol  = "lambda"
  endpoint  = "${aws_lambda_function.lambda.arn}"

  depends_on = ["aws_sns_topic.topic"]
}

resource "aws_lambda_function" "lambda" {
  filename         = "${path.module}/lambdas/ec2_ecs_drainer.zip"
  function_name    = "lambda-handler-${var.ecs_cluster_name}"
  role             = "${var.lambda_iam_role}"
  handler          = "ec2_ecs_drainer.lambda_handler"
  runtime          = "python2.7"
  source_code_hash = "${base64sha256(file("${path.module}/lambdas/ec2_ecs_drainer.zip"))}"
  timeout          = "${var.lambda_timeout}"
}

resource "aws_lambda_permission" "with_sns" {
    statement_id    = "AllowExecutionFromSNS"
    action          = "lambda:InvokeFunction"
    function_name   = "${aws_lambda_function.lambda.arn}"
    principal       = "sns.amazonaws.com"
    source_arn      = "${aws_sns_topic.topic.arn}"

    depends_on = ["aws_sns_topic.topic"]
}

resource "aws_ecs_cluster" "ecs_cluster" {
  name = "${var.ecs_cluster_name}"
}

module "ecs-cluster-lc"   {
  source = "../primitives/lc/"

  lc_name                     = "${var.lc_name}"
  associate_public_ip_address = "${var.lc_associate_public_ip_address}"
  ebs_optimized               = "${var.lc_ebs_optimized}"
  enable_monitoring           = "${var.lc_enable_monitoring}"
  iam_instance_profile        = "${var.lc_iam_instance_profile}"
  ami                         = "${var.lc_ami}"
  instance_type               = "${var.lc_instance_type}"
  key_name                    = "${var.lc_key_name}"
  placement_tenancy           = "${var.lc_placement_tenancy}"
  security_groups             = "${var.lc_security_groups}"
  spot_price                  = "${var.lc_spot_price}"
  ebs_optimized               = "${var.lc_ebs_optimized}"
  ebs_vol_del_on_term         = "${var.lc_ebs_vol_del_on_term}"
  ebs_vol_device_name         = "${var.lc_ebs_vol_device_name}"
  ebs_vol_encrypted           = "${var.lc_ebs_vol_encrypted}"
  ebs_vol_iops                = "${var.lc_ebs_vol_iops}"
  ebs_vol_size                = "${var.lc_ebs_vol_size}"
  ebs_vol_snapshot_id         = "${var.lc_ebs_vol_snapshot_id}"
  ebs_vol_type                = "${var.lc_ebs_vol_type}"
  root_vol_del_on_term        = "${var.lc_root_vol_del_on_term}"
  root_vol_iops               = "${var.lc_root_vol_iops}"
  root_vol_size               = "${var.lc_root_vol_size}"
  root_vol_type               = "${var.lc_root_vol_type}"
  template_file               = "${var.lc_template_file}"
  template_vars               = {
                                  cluster_name = "${var.ecs_cluster_name}"
                                }
}

module "ecs-cluster-asg"   {
  source = "../primitives/asg/"

  asg_name                  = "${var.asg_name}"
  subnets                   = ["${var.asg_subnets}"]
  lc_id                     = "${element(module.ecs-cluster-lc.launch_config_id, 0)}"
  default_cooldown          = "${var.asg_default_cooldown}"
  desired_capacity          = "${var.asg_desired_capacity}"
  enabled_metrics           = ["${var.asg_enabled_metrics}"]
  force_delete              = "${var.asg_force_delete}"
  hc_check_type             = "${var.asg_hc_check_type}"
  hc_grace_period           = "${var.asg_hc_grace_period}"
  max_size                  = "${var.asg_max_size}"
  metrics_granularity       = "1Minute"
  min_size                  = "${var.asg_min_size}"
  placement_group           = "${var.asg_placement_group}"
  protect_from_scale_in     = "${var.asg_protect_from_scale_in}"
  suspended_processes       = ["${var.asg_suspended_processes}"]
  termination_policies      = ["${var.asg_termination_policies}"]
  wait_for_capacity_timeout = "${var.asg_wait_for_capacity_timeout}"
  tags {
     "Z_itops_automation " = "yes"
  }
}

resource "aws_autoscaling_policy" "asg_pol_scale_cpu_up" {
  name                    = "${var.ecs_cluster_name}-pol-instances-scale-cpu-up"
  scaling_adjustment      = "${var.asg_pol_scale_up_scaling_adjustment}"
  adjustment_type         = "ChangeInCapacity"
  cooldown                = "${var.asg_pol_scale_up_cooldown}"
  autoscaling_group_name  = "${module.ecs-cluster-asg.asg_name}"

  depends_on = ["module.ecs-cluster-asg"]
}

resource "aws_autoscaling_policy" "asg_pol_scale_cpu_down" {
  name                    = "${var.ecs_cluster_name}-pol-instances-scale-cpu-down"
  scaling_adjustment      = "${var.asg_pol_scale_down_scaling_adjustment}"
  adjustment_type         = "ChangeInCapacity"
  cooldown                = "${var.asg_pol_scale_down_cooldown}"
  autoscaling_group_name  = "${module.ecs-cluster-asg.asg_name}"

  depends_on = ["module.ecs-cluster-asg"]
}

resource "aws_autoscaling_policy" "asg_pol_scale_mem_up" {
  name                    = "${var.ecs_cluster_name}-pol-instances-scale-mem-up"
  scaling_adjustment      = "${var.asg_pol_scale_up_scaling_adjustment}"
  adjustment_type         = "ChangeInCapacity"
  cooldown                = "${var.asg_pol_scale_up_cooldown}"
  autoscaling_group_name  = "${module.ecs-cluster-asg.asg_name}"

  depends_on = ["module.ecs-cluster-asg"]
}

resource "aws_autoscaling_policy" "asg_pol_scale_mem_down" {
  name                    = "${var.ecs_cluster_name}-pol-instances-scale-mem-down"
  scaling_adjustment      = "${var.asg_pol_scale_down_scaling_adjustment}"
  adjustment_type         = "ChangeInCapacity"
  cooldown                = "${var.asg_pol_scale_down_cooldown}"
  autoscaling_group_name  = "${module.ecs-cluster-asg.asg_name}"

  depends_on = ["module.ecs-cluster-asg"]
}

resource "aws_autoscaling_policy" "asg_pol_scale_memresrv_up" {
  name                    = "${var.ecs_cluster_name}-pol-instances-scale-memresrv-up"
  scaling_adjustment      = "${var.asg_pol_scale_up_scaling_adjustment}"
  adjustment_type         = "ChangeInCapacity"
  cooldown                = "${var.asg_pol_scale_up_cooldown}"
  autoscaling_group_name  = "${module.ecs-cluster-asg.asg_name}"

  depends_on = ["module.ecs-cluster-asg"]
}

resource "aws_autoscaling_policy" "asg_pol_scale_cpuresrv_up" {
  name                    = "${var.ecs_cluster_name}-pol-instances-scale-cpuresrv-up"
  scaling_adjustment      = "${var.asg_pol_scale_up_scaling_adjustment}"
  adjustment_type         = "ChangeInCapacity"
  cooldown                = "${var.asg_pol_scale_up_cooldown}"
  autoscaling_group_name  = "${module.ecs-cluster-asg.asg_name}"

  depends_on = ["module.ecs-cluster-asg"]
}

resource "aws_cloudwatch_metric_alarm" "ecs_cluster_instances_cpuresrv_high" {
  alarm_name            = "${var.ecs_cluster_name}-ecs-cluster-instances-cpuresrv-high"
  comparison_operator   = "${var.cloudwatch_metric_alarm_ec2_cpu_high_comparison_operator}"
  evaluation_periods    = "${var.cloudwatch_metric_alarm_ec2_cpu_high_evaluation_periods}"
  metric_name           = "CPUReservation"
  namespace             = "AWS/ECS"
  period                = "${var.cloudwatch_metric_alarm_ec2_cpu_high_period}"
  statistic             = "${var.cloudwatch_metric_alarm_ec2_cpu_high_statistic}"
  threshold             = "${var.cloudwatch_metric_alarm_ec2_cpu_high_threshold}"
  alarm_actions         = ["${aws_autoscaling_policy.asg_pol_scale_cpuresrv_up.arn}"]

  dimensions {
    ClusterName                 = "${var.ecs_cluster_name}"
  }

  depends_on = ["aws_autoscaling_policy.asg_pol_scale_memresrv_up"]
}

resource "aws_cloudwatch_metric_alarm" "ecs_cluster_instances_memresrv_high" {
  alarm_name            = "${var.ecs_cluster_name}-ecs-cluster-instances-memresrv-high"
  comparison_operator   = "${var.cloudwatch_metric_alarm_ec2_cpu_high_comparison_operator}"
  evaluation_periods    = "${var.cloudwatch_metric_alarm_ec2_cpu_high_evaluation_periods}"
  metric_name           = "MemoryReservation"
  namespace             = "AWS/ECS"
  period                = "${var.cloudwatch_metric_alarm_ec2_cpu_high_period}"
  statistic             = "${var.cloudwatch_metric_alarm_ec2_cpu_high_statistic}"
  threshold             = "${var.cloudwatch_metric_alarm_ec2_cpu_high_threshold}"
  alarm_actions         = ["${aws_autoscaling_policy.asg_pol_scale_memresrv_up.arn}"]

  dimensions {
    ClusterName                 = "${var.ecs_cluster_name}"
  }

  depends_on = ["aws_autoscaling_policy.asg_pol_scale_memresrv_up"]
}

resource "aws_cloudwatch_metric_alarm" "ecs_cluster_instances_cpu_high" {
  alarm_name            = "${var.ecs_cluster_name}-ecs-cluster-instances-cpu-high"
  comparison_operator   = "${var.cloudwatch_metric_alarm_ec2_cpu_high_comparison_operator}"
  evaluation_periods    = "${var.cloudwatch_metric_alarm_ec2_cpu_high_evaluation_periods}"
  metric_name           = "CPUUtilization"
  namespace             = "AWS/ECS"
  period                = "${var.cloudwatch_metric_alarm_ec2_cpu_high_period}"
  statistic             = "${var.cloudwatch_metric_alarm_ec2_cpu_high_statistic}"
  threshold             = "${var.cloudwatch_metric_alarm_ec2_cpu_high_threshold}"
  alarm_actions         = ["${aws_autoscaling_policy.asg_pol_scale_cpu_up.arn}"]

  dimensions {
    ClusterName                 = "${var.ecs_cluster_name}"
  }

  depends_on = ["aws_autoscaling_policy.asg_pol_scale_cpu_up","module.ecs-cluster-asg"]
}

resource "aws_cloudwatch_metric_alarm" "ecs_cluster_instances_cpu_low" {
  alarm_name            = "${var.ecs_cluster_name}-ecs-cluster-instances-cpu-low"
  comparison_operator   = "${var.cloudwatch_metric_alarm_ec2_cpu_low_comparison_operator}"
  evaluation_periods    = "${var.cloudwatch_metric_alarm_ec2_cpu_low_evaluation_periods}"
  metric_name           = "CPUUtilization"
  namespace             = "AWS/ECS"
  period                = "${var.cloudwatch_metric_alarm_ec2_cpu_low_period}"
  statistic             = "${var.cloudwatch_metric_alarm_ec2_cpu_low_statistic}"
  threshold             = "${var.cloudwatch_metric_alarm_ec2_cpu_low_threshold}"
  alarm_actions         = ["${aws_autoscaling_policy.asg_pol_scale_cpu_down.arn}"]

  dimensions {
    ClusterName                 = "${var.ecs_cluster_name}"
  }

  depends_on = ["aws_autoscaling_policy.asg_pol_scale_cpu_down","module.ecs-cluster-asg"]
}

resource "aws_cloudwatch_metric_alarm" "ecs_cluster_instances_memory_high" {
  alarm_name            = "${var.ecs_cluster_name}-ecs-cluster-instances-memory-high"
  comparison_operator   = "${var.cloudwatch_metric_alarm_ec2_memory_high_comparison_operator}"
  evaluation_periods    = "${var.cloudwatch_metric_alarm_ec2_memory_high_evaluation_periods}"
  metric_name           = "MemoryUtilization"
  namespace             = "AWS/ECS"
  period                = "${var.cloudwatch_metric_alarm_ec2_memory_high_period}"
  statistic             = "${var.cloudwatch_metric_alarm_ec2_memory_high_statistic}"
  threshold             = "${var.cloudwatch_metric_alarm_ec2_memory_high_threshold}"
  alarm_actions         = ["${aws_autoscaling_policy.asg_pol_scale_mem_up.arn}"]

  dimensions {
    ClusterName                 = "${var.ecs_cluster_name}"
  }

  depends_on = ["aws_autoscaling_policy.asg_pol_scale_mem_up","module.ecs-cluster-asg"]
}

resource "aws_cloudwatch_metric_alarm" "ecs_cluster_instances_memory_low" {
  alarm_name            = "${var.ecs_cluster_name}-ecs-cluster-instances-memory-low"
  comparison_operator   = "${var.cloudwatch_metric_alarm_ec2_memory_low_comparison_operator}"
  evaluation_periods    = "${var.cloudwatch_metric_alarm_ec2_memory_low_evaluation_periods}"
  metric_name           = "MemoryUtilization"
  namespace             = "AWS/ECS"
  period                = "${var.cloudwatch_metric_alarm_ec2_memory_low_period}"
  statistic             = "${var.cloudwatch_metric_alarm_ec2_memory_low_statistic}"
  threshold             = "${var.cloudwatch_metric_alarm_ec2_memory_low_threshold}"
  alarm_actions         = ["${aws_autoscaling_policy.asg_pol_scale_mem_down.arn}"]

  dimensions {
    ClusterName                 = "${var.ecs_cluster_name}"
  }

  depends_on = ["aws_autoscaling_policy.asg_pol_scale_mem_down","module.ecs-cluster-asg"]
}

resource "aws_autoscaling_lifecycle_hook" "terminate-hook" {
  name                   = "terminate-hook"
  autoscaling_group_name = "${module.ecs-cluster-asg.asg_name}"
  default_result         = "ABANDON"
  heartbeat_timeout      = 900
  lifecycle_transition   = "autoscaling:EC2_INSTANCE_TERMINATING"

  notification_target_arn = "${aws_sns_topic.topic.arn}" #ASGSNSTopic
  role_arn                = "${var.sns_lambda_iam_role}" #SNSLambdaRole

  depends_on = ["aws_sns_topic.topic"] #ASGSNSTopic
}

resource "aws_autoscaling_notification" "ecs-autoscaling-notification" {
  group_names = ["${module.ecs-cluster-asg.asg_name}"]

  notifications = [
    "autoscaling:EC2_INSTANCE_LAUNCH",
    "autoscaling:EC2_INSTANCE_TERMINATE",
    "autoscaling:EC2_INSTANCE_LAUNCH_ERROR",
    "autoscaling:EC2_INSTANCE_TERMINATE_ERROR",
  ]
  topic_arn = "${aws_sns_topic.topic.arn}"

  depends_on = ["aws_sns_topic.topic"]
}
