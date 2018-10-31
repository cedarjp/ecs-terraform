data "aws_elb_service_account" "alb" {}

resource "aws_alb" "alb" {
  idle_timeout    = "${var.alb_idle_timeout}"
  internal        = "${var.alb_internal}"
  name            = "${var.name}"
  security_groups = ["${aws_security_group.sg-lb.id}"]
  subnets         = ["${aws_subnet.main.*.id}"]

  enable_deletion_protection = "${var.alb_deletion_protection}"

  access_logs {
    bucket  = "${aws_s3_bucket.alb_log.bucket}"
    prefix  = "${var.name}-lb"
    enabled = true
  }

  tags {
    Name = "${var.name}"
  }
}

resource "aws_alb_target_group" "alb" {
  name     = "${var.name}-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "${aws_vpc.vpc.id}"
}

resource "aws_alb_listener" "alb" {
  load_balancer_arn = "${aws_alb.alb.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.alb.arn}"
    type             = "forward"
  }
}

resource "aws_alb_listener" "alb-ssl" {
  load_balancer_arn = "${aws_alb.alb.arn}"
  port              = "443"
  protocol          = "HTTPS"
  certificate_arn   = "${aws_acm_certificate_validation.cert.certificate_arn}"

  default_action {
    target_group_arn = "${aws_alb_target_group.alb.arn}"
    type             = "forward"
  }
}
