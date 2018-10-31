resource "aws_cloudwatch_log_group" "ecs_log" {
  name = "${var.name}_ecs"

  tags {
    Environment = "production"
    Application = "serviceA"
  }
}