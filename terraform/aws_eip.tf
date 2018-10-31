resource "aws_eip" "cron" {
  instance = "${aws_instance.cron.id}"
  vpc      = true
}