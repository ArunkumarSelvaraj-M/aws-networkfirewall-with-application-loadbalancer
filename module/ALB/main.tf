resource "aws_lb_target_group" "test" {
  name     = "${local.load_balancer_name}-tg"
  port     = local.port
  protocol = "HTTP"
  vpc_id   = local.vpc_id

  health_check {
    path = "/health"
    protocol = "HTTP"
    port = local.port
    interval = 30
    timeout = 5
    healthy_threshold = 3
    unhealthy_threshold = 2
    matcher = "200-299"
  }
}

resource "aws_lb_target_group_attachment" "test" {
  for_each = { for idx, id in local.instance_ids : idx => id } # Convert list to map
  target_group_arn = aws_lb_target_group.test.arn
  target_id        = each.value
  port             = local.port
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.test.arn
  port              = local.port
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.test.arn
  }
}

resource "aws_lb" "test" {
  name               = local.load_balancer_name
  internal           = false
  load_balancer_type = local.load_balancer_type
  security_groups    = local.security_groups_ids
  subnets            = local.subnet_ids

  # enable_deletion_protection = true
}

