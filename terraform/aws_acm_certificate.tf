resource "aws_acm_certificate" "cert" {
  domain_name       = "${var.domain_name}"
  validation_method = "${var.acm_validation_method}"
}

resource "aws_acm_certificate_validation" "cert" {
  certificate_arn = "${aws_acm_certificate.cert.arn}"
}
