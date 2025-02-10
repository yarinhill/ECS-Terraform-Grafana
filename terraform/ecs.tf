resource "aws_ecs_cluster" "ecs" {
  name = "${var.project_name}-cluster"
}

resource "aws_ecs_task_definition" "prometheus_td" {
  family                   = "${var.project_name}-prometheus"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "512"
  memory                   = "1024"
  execution_role_arn       = aws_iam_role.ecs_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  container_definitions = jsonencode([
    {
      name         = "prometheus"
      image        = "ubuntu/prometheus"
      cpu          = 512
      memory       = 1024
      essential    = true
      portMappings = [
        {
          containerPort = 9090
          hostPort      = 9090
        }
      ]
    }
  ])
}

resource "aws_ecs_task_definition" "grafana_td" {
  family                   = "${var.project_name}-grafana"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "512"
  memory                   = "1024"
  execution_role_arn       = aws_iam_role.ecs_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  container_definitions = jsonencode([
    {
      name         = "grafana"
      image        = "grafana/grafana"
      cpu          = 512
      memory       = 1024
      essential    = true
      environment = [
        { name = "GF_SECURITY_ADMIN_USER", value = var.grafana_admin_user },
        { name = "GF_SECURITY_ADMIN_PASSWORD", value = var.grafana_admin_password }
      ]
      portMappings = [
        {
          containerPort = 3000
          hostPort      = 3000
        }
      ]
    }
  ])
}

resource "aws_ecs_task_definition" "loki_td" {
  family                   = "${var.project_name}-loki"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "512"
  memory                   = "1024"
  execution_role_arn       = aws_iam_role.ecs_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  container_definitions = jsonencode([
    {
      name         = "loki"
      image        = "grafana/loki:latest"
      cpu          = 512
      memory       = 1024
      essential    = true
      portMappings = [
        {
          containerPort = 3100
          hostPort      = 3100
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "prometheus_service" {
  name            = "${var.project_name}-prometheus-service"
  cluster         = aws_ecs_cluster.ecs.id
  task_definition = aws_ecs_task_definition.prometheus_td.arn
  launch_type     = "FARGATE"
  desired_count   = 1
  network_configuration {
    subnets         = module.vpc.private_subnets
    security_groups = [aws_security_group.ecs_sg.id]
  }
  load_balancer {
    target_group_arn = aws_lb_target_group.prometheus_tg.arn
    container_name   = "prometheus"
    container_port   = 9090
  }
}


resource "aws_ecs_service" "grafana_service" {
  name            = "${var.project_name}-grafana-service"
  cluster         = aws_ecs_cluster.ecs.id
  task_definition = aws_ecs_task_definition.grafana_td.arn
  launch_type     = "FARGATE"
  desired_count   = 1
  network_configuration {
    subnets         = module.vpc.private_subnets
    security_groups = [aws_security_group.ecs_sg.id]
  }
  load_balancer {
    target_group_arn = aws_lb_target_group.grafana_tg.arn
    container_name   = "grafana"
    container_port   = 3000
  }
}


resource "aws_ecs_service" "loki_service" {
  name            = "${var.project_name}-loki-service"
  cluster         = aws_ecs_cluster.ecs.id
  task_definition = aws_ecs_task_definition.loki_td.arn
  launch_type     = "FARGATE"
  desired_count   = 1
  network_configuration {
    subnets         = module.vpc.private_subnets
    security_groups = [aws_security_group.ecs_sg.id]
  }
  load_balancer {
    target_group_arn = aws_lb_target_group.loki_tg.arn
    container_name   = "loki"
    container_port   = 3100
  }
}


resource "aws_iam_role" "ecs_task_role" {
  name = "${var.project_name}-task-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role" "ecs_execution_role" {
  name = "${var.project_name}-execution-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_role_policy_attachment" {
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "ecs_execution_role_policy_attachment" {
  role       = aws_iam_role.ecs_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
