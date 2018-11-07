resource "aws_security_group" "sg" {
  name        = "${var.sg_name}"
  description = "${var.sg_description}"
  vpc_id      = "${var.vpc_id}"
  tags             = "${merge(
                               var.tags, map("Name", format("%s-sg", var.sg_name)),
                               var.tags, map("Z_name", format("%s-sg", var.sg_name)),
                               var.tags, map("Z_type", "SecurityGroup")
                             )}"
}

resource "aws_security_group_rule" "sg_ingress_rule" {
  count             = "${length(var.inbound_rules)}"
  type              = "ingress"
  cidr_blocks       = ["${element(var.inbound_rules[count.index], 0)}"]
  from_port         = "${element(var.inbound_rules[count.index], 1)}"
  to_port           = "${element(var.inbound_rules[count.index], 2)}"
  protocol          = "${element(var.inbound_rules[count.index], 3)}"
  security_group_id = "${aws_security_group.sg.id}"
}

resource "aws_security_group_rule" "sg_egress_rule" {
  count             = "${length(var.outbound_rules)}"
  type              = "egress"
  cidr_blocks       = ["${element(var.outbound_rules[count.index], 0)}"]
  from_port         = "${element(var.outbound_rules[count.index], 1)}"
  to_port           = "${element(var.outbound_rules[count.index], 2)}"
  protocol          = "${element(var.outbound_rules[count.index], 3)}"
  security_group_id = "${aws_security_group.sg.id}"
}
