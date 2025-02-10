output "aws_region" {
  description = "The AWS region"
  value       = var.region_master
}

output "ecs_cluster_name" {
  description = "The name of the ECS cluster"
  value       = aws_ecs_cluster.ecs.name
}

output "ALB-DNS-NAME" {
  description = "The DNS of the ALB"
  value = aws_lb.app_alb.dns_name
}