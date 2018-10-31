resource "aws_route53_zone" "app" {
  name = "${var.domain_name}"
}

resource "aws_route53_record" "app" {
  zone_id = "${aws_route53_zone.app.id}"
  name    = "${var.domain_name}"
  type    = "A"

  alias {
    evaluate_target_health = false
    name                   = "${aws_alb.alb.dns_name}"
    zone_id                = "${aws_alb.alb.zone_id}"
  }
}
