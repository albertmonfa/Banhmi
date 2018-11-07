data "template_file" "user_data" {
  template = "${file(format("%s/user-data-tmpls/%s.tpl", path.module, var.template_file))}"
  vars = "${var.template_vars}"
}

resource "aws_launch_configuration" "lc" {
  count = "${length(var.ebs_vol_device_name) > 0 ? 0 : 1}"

  name                        = "${var.lc_name}"
  associate_public_ip_address = "${var.associate_public_ip_address}"
  ebs_optimized               = "${var.ebs_optimized}"
  enable_monitoring           = "${var.enable_monitoring}"
  iam_instance_profile        = "${var.iam_instance_profile}"
  image_id                    = "${var.ami}"
  instance_type               = "${var.instance_type}"
  key_name                    = "${var.key_name}"
  placement_tenancy           = "${var.placement_tenancy}"
  security_groups             = ["${var.security_groups}"]
  spot_price                  = "${var.spot_price}"
  user_data                   = "${data.template_file.user_data.rendered}"

  root_block_device {
    delete_on_termination = "${var.root_vol_del_on_term}"
    iops                  = "${var.root_vol_type == "io1" ? var.root_vol_iops : "0" }"
    volume_size           = "${length(var.root_vol_size) > 0 ? var.root_vol_size : "8"}"
    volume_type           = "${var.root_vol_type}"
  }

  lifecycle {
    create_before_destroy = false
  }
}

resource "aws_launch_configuration" "lc_ebs" {
  count = "${length(var.ebs_vol_device_name) > 0 ? 1 : 0}"

  name                        = "${var.lc_name}"
  associate_public_ip_address = "${var.associate_public_ip_address}"
  ebs_optimized               = "${var.ebs_optimized}"
  enable_monitoring           = "${var.enable_monitoring}"
  iam_instance_profile        = "${var.iam_instance_profile}"
  image_id                    = "${var.ami}"
  instance_type               = "${var.instance_type}"
  key_name                    = "${var.key_name}"
  placement_tenancy           = "${var.placement_tenancy}"
  security_groups             = ["${var.security_groups}"]
  spot_price                  = "${var.spot_price}"
  user_data                   = "${data.template_file.user_data.rendered}"

  root_block_device {
    delete_on_termination = "${var.root_vol_del_on_term}"
    iops                  = "${var.root_vol_type == "io1" ? var.root_vol_iops : "0" }"
    volume_size           = "${length(var.root_vol_size) > 0 ? var.root_vol_size : "0"}"
    volume_type           = "${var.root_vol_type}"
  }

  ebs_block_device {
    delete_on_termination = "${var.ebs_vol_del_on_term}"
    device_name           = "${var.ebs_vol_device_name}"
    encrypted             = "${length(var.ebs_vol_snapshot_id) > 0 ? "" : var.ebs_vol_encrypted}"
    iops                  = "${var.ebs_vol_type == "io1" ? var.ebs_vol_iops : "0" }"
    snapshot_id           = "${var.ebs_vol_snapshot_id}"
    volume_size           = "${length(var.ebs_vol_snapshot_id) > 0 ? "0" : var.ebs_vol_size}"
    volume_type           = "${var.ebs_vol_type}"
  }

  lifecycle {
    create_before_destroy = false
  }
}
