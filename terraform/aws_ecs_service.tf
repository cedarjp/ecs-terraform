resource "aws_ecs_service" "ecs" {
  name            = "${var.name}"
  cluster         = "${aws_ecs_cluster.ecs.id}"
  task_definition = "${aws_ecs_task_definition.ecs.arn}"
  desired_count   = 1
  iam_role        = "${aws_iam_role.ecs_role.arn}"
  depends_on      = ["aws_iam_role_policy.ecs_role"]

  load_balancer {
    container_name   = "nginx"
    container_port   = 80
    target_group_arn = "${aws_alb_target_group.alb.arn}"
  }

  lifecycle {
    ignore_changes = ["desired_count"]
  }
}

resource "aws_appautoscaling_target" "ecs_target" {
  max_capacity = 5
  min_capacity = 1
  resource_id  = "service/${aws_ecs_cluster.ecs.name}/${aws_ecs_service.ecs.name}"

  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "scale_out" {
  name = "scale-out"
  policy_type = "StepScaling"
  resource_id = "service/${aws_ecs_cluster.ecs.name}/${aws_ecs_service.ecs.name}"
  depends_on = ["aws_appautoscaling_target.ecs_target"]
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace = "ecs"
  step_scaling_policy_configuration {
    adjustment_type = "ChangeInCapacity"
    cooldown = 60
    metric_aggregation_type = "Average"
    step_adjustment {
      metric_interval_lower_bound = 0
      scaling_adjustment = 1
    }
  }
}

resource "aws_appautoscaling_policy" "scale_in" {
  name = "scale-in"
  policy_type = "StepScaling"
  resource_id = "service/${aws_ecs_cluster.ecs.name}/${aws_ecs_service.ecs.name}"
  depends_on = ["aws_appautoscaling_target.ecs_target"]
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace = "ecs"
  step_scaling_policy_configuration {
    adjustment_type = "ChangeInCapacity"
    cooldown = 60
    metric_aggregation_type = "Average"
    step_adjustment {
      metric_interval_upper_bound = 0
      scaling_adjustment = -1
    }
  }
}

resource "aws_autoscaling_policy" "scale_out" {
  name = "Instance-ScaleOut-CPU-High"
  scaling_adjustment = 1
  adjustment_type = "ChangeInCapacity"
  cooldown = 300
  autoscaling_group_name = "${aws_autoscaling_group.asg.name}"
}

resource "aws_autoscaling_policy" "scale_in" {
  name = "Instance-ScaleIn-CPU-Low"
  scaling_adjustment = -1
  adjustment_type = "ChangeInCapacity"
  cooldown = 300
  autoscaling_group_name = "${aws_autoscaling_group.asg.name}"
}

resource "aws_cloudwatch_metric_alarm" "ecs_cluster_high" {
  alarm_name = "${var.name}-cluster-CPU-Utilization-High"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods = "1"
  metric_name = "CPUUtilization"
  namespace = "AWS/ECS"
  period = "300"
  statistic = "Average"
  threshold = "50"
  dimensions {
    ClusterName = "${aws_ecs_cluster.ecs.name}"
  }
  alarm_actions = ["${aws_autoscaling_policy.scale_out.arn}"]
}

resource "aws_cloudwatch_metric_alarm" "ecs_cluster_low" {
  alarm_name = "${var.name}-cluster-CPU-Utilization-Low"
  comparison_operator = "LessThanThreshold"
  evaluation_periods = "1"
  metric_name = "CPUUtilization"
  namespace = "AWS/ECS"
  period = "300"
  statistic = "Average"
  threshold = "10"
  dimensions {
    ClusterName = "${aws_ecs_cluster.ecs.name}"
  }
  alarm_actions = ["${aws_autoscaling_policy.scale_in.arn}"]
}

resource "aws_cloudwatch_metric_alarm" "ecs_service_high" {
  alarm_name = "${var.name}-service-CPU-Utilization-High"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods = "1"
  metric_name = "CPUUtilization"
  namespace = "AWS/ECS"
  period = "300"
  statistic = "Average"
  threshold = "50"
  dimensions {
    ClusterName = "${aws_ecs_cluster.ecs.name}"
    ServiceName = "${aws_ecs_service.ecs.name}"
  }
  alarm_actions = ["${aws_appautoscaling_policy.scale_out.arn}"]
}

resource "aws_cloudwatch_metric_alarm" "ecs_service_low" {
  alarm_name = "${var.name}-service-CPU-Utilization-Low"
  comparison_operator = "LessThanThreshold"
  evaluation_periods = "1"
  metric_name = "CPUUtilization"
  namespace = "AWS/ECS"
  period = "180"
  statistic = "Average"
  threshold = "10"
  dimensions {
    ClusterName = "${aws_ecs_cluster.ecs.name}"
    ServiceName = "${aws_ecs_service.ecs.name}"
  }
  alarm_actions = ["${aws_appautoscaling_policy.scale_in.arn}"]
}