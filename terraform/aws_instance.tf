data "aws_ami" "amazon" {
  most_recent = true
  owners = ["amazon"]

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "name"
    values = ["amzn-ami-hvm-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "block-device-mapping.volume-type"
    values = ["gp2"]
  }
}

data "template_file" "user_data_cron" {
  template = "${file("${path.module}/templates/user_data_cron.tpl")}"

  vars {
  }
}


resource "aws_instance" "cron" {
  ami                         = "${data.aws_ami.amazon.id}"
  instance_type               = "t2.micro"
  key_name                    = "${aws_key_pair.key.key_name}"
  subnet_id                   = "${aws_subnet.main.0.id}"
  vpc_security_group_ids      = ["${aws_security_group.sg.id}"]
  user_data                   = "${data.template_file.user_data_cron.rendered}"
  associate_public_ip_address = "true"
  iam_instance_profile        = "${aws_iam_instance_profile.ec2_cron.name}"

  tags {
    Name = "${var.name}-cron"
    Role = "cron"
  }
}
