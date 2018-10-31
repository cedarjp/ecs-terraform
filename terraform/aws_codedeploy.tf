resource "aws_codedeploy_app" "cron-provisioning" {
  name = "cron-provisioning"
}

resource "aws_codedeploy_deployment_group" "cron-provisioning-group"
{
  app_name = "${aws_codedeploy_app.cron-provisioning.name}"
  deployment_group_name = "cron-group"
  service_role_arn = "${aws_iam_role.codedeploy.arn}"
  ec2_tag_filter {
    key = "Role"
    value = "cron"
    type = "KEY_AND_VALUE"
  }
  deployment_config_name = "CodeDeployDefault.AllAtOnce"
}