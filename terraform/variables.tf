variable "profile" {
  type    = string
  default = "default"
}

variable "region_master" {
  type    = string
  default = "us-east-2"
}

variable "project_name" {
  type    = string
  default = "ecs-project"
}

variable "vpc_cidr" {
  type        = string
  default     = "192.168.0.0/16"  
}

variable "your_public_ip" {
  type    = list(string)
  default = ["1.1.1.1/32"]
}

variable "public_subnets" {
  type        = list(string)
  default     = ["192.168.0.0/20", "192.168.16.0/20", "192.168.32.0/20"]
}

variable "private_subnets" {
  type        = list(string)
  default     = ["192.168.48.0/20", "192.168.64.0/20", "192.168.80.0/20"]
}

variable "grafana_admin_user" {
  type = string
  default = "admin"
}

variable "grafana_admin_password" {
  type = string
  default = "admin"
}