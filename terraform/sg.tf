resource "aws_security_group" "ecs_sg" {
  provider    = aws.region-master
  name        = "${var.project_name}-ecs-sg"
  description = "Allow 3000"
  vpc_id      = module.vpc.vpc_id
  ingress {
    description = "Allow 3000"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    security_groups =  [aws_security_group.alb_sg.id]
  }
  ingress {
    description = "Allow 9090"
    from_port   = 9090
    to_port     = 9090
    protocol    = "tcp"
    security_groups =  [aws_security_group.alb_sg.id]
  }
    ingress {
    description = "Allow 3100"
    from_port   = 3100
    to_port     = 3100
    protocol    = "tcp"
    security_groups =  [aws_security_group.alb_sg.id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.project_name}-sg"
  }
}

resource "aws_security_group" "alb_sg" {
  name        = "${var.project_name}-alb-sg"
  description = "Security group for ALB"
  vpc_id      = module.vpc.vpc_id
  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = var.your_public_ip
  }
  ingress {
    from_port   = 9090
    to_port     = 9090
    protocol    = "tcp"
    cidr_blocks = var.your_public_ip
  }
  ingress {
    from_port   = 3100
    to_port     = 3100
    protocol    = "tcp"
    cidr_blocks = var.your_public_ip
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.project_name}-alb-sg"
  }
}
