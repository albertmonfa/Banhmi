output "role-ecs-instance" {
  value = "${module.role-ecs-instance.role_arn}"
}

output "ecs-instance-profile" {
  value = "${module.ecs-instance-profile.name}"
}

output "role-ecs-service" {
  value = "${module.role-ecs-service.role_arn}"
}

output "role-ecs-service-autoscale" {
  value = "${module.role-ecs-service-autoscale.role_arn}"
}

output "task_role_arn" {
  value = "${aws_iam_role.role-ecs-task-default.arn}"
}

output "role-ecs-lambda" {
  value = "${module.role-ecs-lambda.role_arn}"
}

output "role-sns-lambda" {
  value = "${module.role-sns-lambda.role_arn}"
}
