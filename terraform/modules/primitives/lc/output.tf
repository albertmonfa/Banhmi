output "launch_config_id" {
  value = "${aws_launch_configuration.lc.*.id}"
}

output "launch_config_name" {
  value = "${aws_launch_configuration.lc.*.name}"
}
