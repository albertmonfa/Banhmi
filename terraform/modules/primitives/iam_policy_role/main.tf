resource "aws_iam_role_policy" "iam_role_policy" {
  count             = "${length(var.policies)}"

  role = "${var.role}"
  name = "${element(var.policies[count.index], 0)}"
  policy = "${file(element(var.policies[count.index], 1))}"

  lifecycle { create_before_destroy = true }
}
