data "template_file" "ecs_definition" {
  template = "${file("${path.module}/templates/aws_ecs_task_definition.json")}"

  vars {
    uwsgi_repository_url = "${aws_ecr_repository.uwsgi.repository_url}"
    nginx_repository_url = "${aws_ecr_repository.nginx.repository_url}"
    uwsgi_memory = "${var.task_uwsgi_memory}"
    nginx_memory = "${var.task_nginx_memory}"
    task_django_setting_module = "${var.task_django_setting_module}"
    log_group_name = "${aws_cloudwatch_log_group.ecs_log.name}"
    name = "${var.name}"
  }
}

resource "aws_ecs_task_definition" "ecs" {
  family       = "${var.name}"
  network_mode = "bridge"

  volume = [{
    name      = "volume-0"
    host_path = "/docker_volumes/static"
  },
    {
      name      = "volume-1"
      host_path = "/app/static"
    },
  ]

  container_definitions = "${data.template_file.ecs_definition.rendered}"
}
