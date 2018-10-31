data "template_file" "user_data" {
  template = "${file("${path.module}/templates/user_data.tpl")}"

  vars {
    cluster_name = "${aws_ecs_cluster.ecs.name}"
  }
}

resource "aws_launch_configuration" "ecs-lc" {
  name_prefix                 = "${var.name}-lc-"
  image_id                    = "${var.image_id}"
  instance_type               = "${var.instance_type}"
  iam_instance_profile        = "${aws_iam_instance_profile.instance_role.arn}"
  key_name                    = "${aws_key_pair.key.key_name}"
  security_groups             = ["${aws_security_group.sg.id}"]
  associate_public_ip_address = "${var.lc_public_ip}"
  user_data                   = "${data.template_file.user_data.rendered}"
  enable_monitoring           = "${var.lc_enable_monitoring}"
  ebs_optimized               = "${var.lc_ebs_optimized}"

  ebs_block_device {
    device_name           = "${var.lc_device_name}"
    volume_type           = "${var.lc_volume_type}"
    volume_size           = "${var.lc_volume_size}"
    delete_on_termination = "${var.lc_delete_on_termination}"
  }

  lifecycle {
    create_before_destroy = true
  }
}
