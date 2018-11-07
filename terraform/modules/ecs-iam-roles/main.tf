module "role-ecs-instance"   {
  source    = "../primitives/iam_role"

  name               = "${var.prefix-name}-ecs-role-instance"
  assume_role_policy = "${path.module}/policies/ecs-instance.json"
  policies_files = {
        "0" = [ "${var.prefix-name}-ecs-instance-policy",
                "${path.module}/policies/ecs-instance-policy.json"
              ]
  }
}

module "ecs-instance-profile"   {
  source = "../primitives/iam_instance_profile"

  profile-name  = "${var.prefix-name}-ecs-instance-profile"
  role-name     = "${module.role-ecs-instance.role_id}"
}

module "role-ecs-service"   {
  source    = "../primitives/iam_role"

  name                = "${var.prefix-name}-ecs-role-service"
  assume_role_policy  = "${path.module}/policies/ecs-service.json"
  policies_arn = {
        "0" = [ "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceRole"]
  }
}

resource "aws_iam_role" "role-ecs-task-default" {
  name                  = "${var.prefix-name}-ecs-role-task-default"
  assume_role_policy    = "${file("${path.module}/policies/ecs-task.json")}"

  lifecycle { create_before_destroy = true }
}


module "role-ecs-task-default-policy"   {
  source   = "../primitives/iam_policy_role"

  role     = "${aws_iam_role.role-ecs-task-default.name}"
  policies = {
        "0" = [ "${aws_iam_role.role-ecs-task-default.name}","${path.module}/policies/ecs-task-default.json" ]
  }
}

module "role-ecs-service-autoscale"   {
  source    = "../primitives/iam_role"

  name                = "${var.prefix-name}-ecs-service-autoscale"
  assume_role_policy  = "${path.module}/policies/ecs-service-autoscale.json"
  policies_files = {
        "0" = [ "${var.prefix-name}-ecs-autoscale-policy",
                "${path.module}/policies/ecs-service-autoscale-policy.json"
              ]
  }
  policies_arn = {
        "0" = [ "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceAutoscaleRole"]
        "1" = [ "arn:aws:iam::aws:policy/CloudWatchReadOnlyAccess" ]
  }
}

module "role-ecs-lambda"   {
  source    = "../primitives/iam_role"

  name                = "${var.prefix-name}-ecs-role-lambda-execution"
  assume_role_policy  = "${path.module}/policies/lambda.json"
  policies_files = {
        "0" = [ "${var.prefix-name}-lambda-execution-policy",
                "${path.module}/policies/lambda-policy.json"
              ]
  }
  policies_arn = {
        "0" = [ "arn:aws:iam::aws:policy/service-role/AutoScalingNotificationAccessRole"]
  }
}

module "role-sns-lambda"   {
  source    = "../primitives/iam_role"

  name                = "${var.prefix-name}-role-sns-lambda"
  assume_role_policy  = "${path.module}/policies/sns-lambda.json"
  policies_arn = {
        "0" = [ "arn:aws:iam::aws:policy/service-role/AutoScalingNotificationAccessRole"]
  }
}
