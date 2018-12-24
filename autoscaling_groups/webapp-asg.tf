resource "aws_autoscaling_group" "mywebapp_asg" {
  lifecycle { create_before_destroy = true }
  vpc_zone_identifier = ["${var.private_subnets_id}"]
  name = "my_webapp_asg-${var.mywebapp_lc_name}"
  max_size = "${var.asg_max}"
  min_size = "${var.asg_min}"
  wait_for_elb_capacity = false
  force_delete = true
  launch_configuration = "${var.mywebapp_lc_id}"
  load_balancers = ["${var.mywebapp_elb_name}"]
  tag {
    key = "Name"
    value = "mywebapp_asg"
    propagate_at_launch = "true"
  }
}

#
# Scale Up Policy and Alarm
#
resource "aws_autoscaling_policy" "scale_up" {
  name = "my_asg_scale_up"
  scaling_adjustment = 2
  adjustment_type = "ChangeInCapacity"
  cooldown = 300
  autoscaling_group_name = "${aws_autoscaling_group.mywebapp_asg.name}"
}
resource "aws_cloudwatch_metric_alarm" "scale_up_alarm" {
  alarm_name = "mywebapp-high-asg-cpu"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods = "2"
  metric_name = "CPUUtilization"
  namespace = "AWS/EC2"
  period = "120"
  statistic = "Average"
  threshold = "80"
  insufficient_data_actions = []
  dimensions {
      AutoScalingGroupName = "${aws_autoscaling_group.mywebapp_asg.name}"
  }
  alarm_description = "EC2 CPU Utilization"
  alarm_actions = ["${aws_autoscaling_policy.scale_up.arn}"]
}

#
# Scale Down Policy and Alarm
#
resource "aws_autoscaling_policy" "scale_down" {
  name = "mywebapp_asg_scale_down"
  scaling_adjustment = -1
  adjustment_type = "ChangeInCapacity"
  cooldown = 600
  autoscaling_group_name = "${aws_autoscaling_group.mywebapp_asg.name}"
}

resource "aws_cloudwatch_metric_alarm" "scale_down_alarm" {
  alarm_name = "mywebapp-low-asg-cpu"
  comparison_operator = "LessThanThreshold"
  evaluation_periods = "5"
  metric_name = "CPUUtilization"
  namespace = "AWS/EC2"
  period = "120"
  statistic = "Average"
  threshold = "30"
  insufficient_data_actions = []
  dimensions {
      AutoScalingGroupName = "${aws_autoscaling_group.mywebapp_asg.name}"
  }
  alarm_description = "EC2 CPU Utilization"
  alarm_actions = ["${aws_autoscaling_policy.scale_down.arn}"]
}
output "asg_id" {
  value = "${aws_autoscaling_group.mywebapp_asg.id}"
}
