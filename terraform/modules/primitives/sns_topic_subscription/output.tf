output "id" {
  value = "${aws_sns_topic_subscription.topic_subscription.id}"
}

output "topic_arn" {
  value = "${aws_sns_topic_subscription.topic_subscription.topic_arn}"
}

output "protocol" {
  value = "${aws_sns_topic_subscription.topic_subscription.protocol}"
}

output "endpoint" {
  value = "${aws_sns_topic_subscription.topic_subscription.endpoint }"
}

output "arn" {
  value = "${aws_sns_topic_subscription.topic_subscription.arn}"
}
