resource "aws_iam_instance_profile" "iam_instance_profile" {
  name          = "${var.profile-name}"
  role          = "${var.role-name}"

  lifecycle { create_before_destroy = true }
}
