output "mywebapp_elb_dns_name" {
  description = "The DNS name of the ELB"
  value       = "${module.load_balancers.mywebapp_elb_dns}"
}