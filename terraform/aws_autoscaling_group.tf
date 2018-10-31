resource "aws_autoscaling_group" "asg" {
  name_prefix               = "${var.name}-asg-"
  vpc_zone_identifier       = ["${aws_subnet.main.*.id}"]
  launch_configuration      = "${aws_launch_configuration.ecs-lc.name}"
  max_size                  = "${var.asg_max_size}"
  min_size                  = "${var.asg_min_size}"
  desired_capacity          = "${var.asg_desired_capacity}"
  health_check_grace_period = "${var.asg_health_check_grace_period}"
  health_check_type         = "${var.asg_health_check_type}"

  tag {
    key                 = "Name"
    value               = "ECS Instance - ${var.name}"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}
