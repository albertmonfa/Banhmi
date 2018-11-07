output "ids" {
  value = "${aws_iam_role_policy.iam_role_policy.*.id}"
}

output "names" {
  value = "${aws_iam_role_policy.iam_role_policy.*.name}"
}

output "policies" {
  value = "${aws_iam_role_policy.iam_role_policy.*.policy}"
}

output "roles" {
  value = "${aws_iam_role_policy.iam_role_policy.*.role}"
}
