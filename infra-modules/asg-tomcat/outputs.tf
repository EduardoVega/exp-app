output "load-balancer-domain-name" {
  value = aws_lb.lb.dns_name 
  description = "Load Balancer Domain Name for the Tomcat VMs"
}