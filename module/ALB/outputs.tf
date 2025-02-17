output "lb_target_group_arn" {
  description = "The ARN of the load balancer target group"
  value       = aws_lb_target_group.test.arn
}

output "lb_target_group_name" {
  description = "The name of the load balancer target group"
  value       = aws_lb_target_group.test.name
}

output "lb_listener_arn" {
  description = "The ARN of the load balancer listener"
  value       = aws_lb_listener.front_end.arn
}

output "lb_listener_port" {
  description = "The port of the load balancer listener"
  value       = aws_lb_listener.front_end.port
}

output "load_balancer_arn" {
  description = "The ARN of the load balancer"
  value       = aws_lb.test.arn
}

output "load_balancer_dns_name" {
  description = "The DNS name of the load balancer"
  value       = aws_lb.test.dns_name
}

output "load_balancer_id" {
  description = "The ID of the load balancer"
  value       = aws_lb.test.id
}


