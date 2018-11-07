resource "aws_iam_role" "iam_role" {
  name                  = "${var.name}"
  assume_role_policy    = "${file("${var.assume_role_policy}")}"

  lifecycle { create_before_destroy = true }
}

module "iam_policies_role"   {
  source = "../iam_policy_role/"

  role          = "${aws_iam_role.iam_role.name}"
  policies      = "${var.policies_files}"
}

module "iam_policies_role_attachment"   {
  source = "../iam_policy_role_attachment/"

  role          = "${aws_iam_role.iam_role.name}"
  policies      = "${var.policies_arn}"

}
