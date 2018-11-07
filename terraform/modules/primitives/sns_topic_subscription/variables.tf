variable "topic_arn" {
  type        = "string"
  description = "The ARN of the SNS topic to subscribe to"
}

variable "protocol" {
  type        = "string"
  description = "The protocol to use. The possible values for this are: sqs, sms, lambda, application. (http or https are partially supported, see below) (email is option but unsupported, see below)."
}

variable "endpoint" {
  type        = "string"
  description = "The endpoint to send data to, the contents will vary with the protocol. (see below for more information)"
}

variable "endpoint_auto_confirms" {
  type        = "string"
  description = "Boolean indicating whether the end point is capable of auto confirming subscription e.g., PagerDuty (default is false)"
  default     = "false"
}

variable "confirmation_timeout_in_minutes" {
  type        = "string"
  description = "Integer indicating number of minutes to wait in retying mode for fetching subscription arn before marking it as failure. Only applicable for http and https protocols (default is 1 minute)."
  default     = "1"
}

variable "raw_message_delivery" {
  type        = "string"
  description = "Boolean indicating whether or not to enable raw message delivery (the original message is directly passed, not wrapped in JSON with the original message in the message property) (default is false)."
  default     = "false"
}
