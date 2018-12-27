resource "aws_elb" "mywebapp_elb" {
  name = "mywebapp-elb"
  subnets = ["${var.public_subnets_id}"]
  access_logs {
    bucket = "${var.elb_log_s3}"
    interval = 5
  }
  listener {
    instance_port = 80
    instance_protocol = "http"
    lb_port = 80
    lb_protocol = "http"
  }
  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    target = "HTTP:80/"
    interval = 10
  }
  security_groups = ["${var.mywebapp_http_inbound_sg_id}"]
  tags {
      Name = "mywebapp-elb"
  }
}
output "mywebapp_elb_name" {
  value = "${aws_elb.mywebapp_elb.name}"
}
output "mywebapp_elb_dns" {
  value = "${aws_elb.mywebapp_elb.dns_name}"
}
resource aws_cloudwatch_metric_alarm "mywebapp_alerting" {
  alarm_name          = "mywebapp-alerting"
  namespace           = "AWS/ELB"
  metric_name = "HealthyHostCount"
  comparison_operator = "LessThanThreshold"
  threshold = "3"
  statistic = "Minimum"
  evaluation_periods  = "1"
  period              = "60"
  dimensions {
    LoadBalancerName = "${aws_elb.mywebapp_elb.name}"
  }

  alarm_description = "SNS if instance are less then threshold"

  alarm_actions = ["${aws_sns_topic.mywebapp_sns.arn}"]
}

resource aws_sns_topic "mywebapp_sns" {
  name = "mywebapp-sns"
}

resource aws_sns_topic_policy "mywebapp_sns_policy" {
  arn    = "${aws_sns_topic.mywebapp_sns.arn}"
  policy = "${data.aws_iam_policy_document.mywebapp_sns_policy.json}"
}

data aws_iam_policy_document "mywebapp_sns_policy" {
  statement {
    actions = [
      "SNS:Publish",
    ]

    resources = [
      "${aws_sns_topic.mywebapp_sns.arn}",
    ]

    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }
  }
}