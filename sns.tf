resource "aws_sns_topic" "team2" {
  name = "team2"
  delivery_policy = <<EOF
{
  "http": {
    "defaultHealthyRetryPolicy": {
      "minDelayTarget": 20,
      "maxDelayTarget": 20,
      "numRetries": 3,
      "numMaxDelayRetries": 0,
      "numNoDelayRetries": 0,
      "numMinDelayRetries": 0,
      "backoffFunction": "linear"
    },
    "disableSubscriptionOverrides": false,
    "defaultThrottlePolicy": {
      "maxReceivesPerSecond": 1
    }
  }
}
EOF
}
resource "aws_sns_topic_subscription" "team2" {
  topic_arn = aws_sns_topic.team2.id
  protocol  = "sms"
  endpoint  = "2026707710"# needs phone number
}

resource "aws_cloudwatch_metric_alarm" "nlb_healthyhosts" {
  alarm_name          = "alarmname"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "HealthyHostCount"
  namespace           = "AWS/NetworkELB"
  period              = "60"
  statistic           = "Average"
  threshold           = "80"
  alarm_description   = "Number of healthy nodes in Target Group"
  actions_enabled     = "true"
  alarm_actions       = [aws_sns_topic.team2.arn]
  ok_actions          = [aws_sns_topic.team2.arn]
  dimensions = {
    TargetGroup  = aws_lb_target_group.web_tg.arn
    LoadBalancer = aws_lb.web_lb.arn
  }
}