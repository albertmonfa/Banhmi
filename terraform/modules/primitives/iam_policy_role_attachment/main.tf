
resource "aws_iam_role_policy_attachment" "iam_role_policy_attachment" {
  count             = "${length(var.policies)}"

  role = "${var.role}"
  policy_arn = "${element(var.policies[count.index], 0)}"

  lifecycle { create_before_destroy = true }
}
