resource "aws_elb" "mywebapp_elb" {
  name = "mywebapp-elb"
  subnets = ["${var.public_subnets_id}"]
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