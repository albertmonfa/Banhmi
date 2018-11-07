output "role_id" {
  value = "${aws_iam_role.iam_role.id}"
}

output "role_arn" {
  value = "${aws_iam_role.iam_role.arn}"
}

output "role_assume_role_policy" {
  value = "${aws_iam_role.iam_role.assume_role_policy}"
}

output "role_path" {
  value = "${aws_iam_role.iam_role.path}"
}

output "role_unique_id" {
  value = "${aws_iam_role.iam_role.unique_id}"
}

output "iam_policies_role_ids" {
  value = "${module.iam_policies_role.ids}"
}

output "iam_policies_role_names" {
  value = "${module.iam_policies_role.names}"
}

output "iam_policies_role_policies" {
  value = "${module.iam_policies_role.policies}"
}

output "iam_policies_role_roles" {
  value = "${module.iam_policies_role.roles}"
}
