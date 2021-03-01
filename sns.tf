# resource "aws_sns_topic" "team2" {
#   name = "team2"
#   delivery_policy = <<EOF
# {
#   "http": {
#     "defaultHealthyRetryPolicy": {
#       "minDelayTarget": 20,
#       "maxDelayTarget": 20,
#       "numRetries": 3,
#       "numMaxDelayRetries": 0,
#       "numNoDelayRetries": 0,
#       "numMinDelayRetries": 0,
#       "backoffFunction": "linear"
#     },
#     "disableSubscriptionOverrides": false,
#     "defaultThrottlePolicy": {
#       "maxReceivesPerSecond": 1
#     }
#   }
# }
# EOF
# }
# resource "aws_sns_topic_subscription" "team2" {
#   topic_arn = "arn:aws:sns:us-west-2:086790382789:team2"
#   protocol  = "sms"
#   endpoint  = "phone number"# needs phone number
# }