data "aws_kms_alias" "s3kmskey" {
  name = "alias/aws/s3"
}

resource "aws_codepipeline" "pipeline" {
  name     = "${var.name}"
  role_arn = "${aws_iam_role.codepipeline.arn}"

  artifact_store {
    location = "${aws_s3_bucket.codepipeline.bucket}"
    type     = "S3"

    encryption_key {
      id   = "${data.aws_kms_alias.s3kmskey.arn}"
      type = "KMS"
    }
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "ThirdParty"
      provider         = "GitHub"
      version          = "1"
      output_artifacts = ["MyApp"]

      configuration {
        Owner  = "${var.github_owner}"
        Repo   = "${var.github_repository}"
        Branch = "${var.github_branch}"
      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["MyApp"]
      output_artifacts = ["MyAppBuild"]
      version          = "1"

      configuration {
        ProjectName = "${var.name}"
      }
    }
  }

  stage {
    name = "CronDeploy"

    action {
      category        = "Deploy"
      name            = "CronDeploy"
      owner           = "AWS"
      provider        = "CodeDeploy"
      version         = "1"
      input_artifacts = ["MyApp"]

      configuration {
        ApplicationName = "${aws_codedeploy_app.cron-provisioning.name}"
        DeploymentGroupName = "${aws_codedeploy_deployment_group.cron-provisioning-group.deployment_group_name}"
      }
    }
  }

  stage {
    name = "Staging"

    action {
      category        = "Deploy"
      name            = "Staging"
      owner           = "AWS"
      provider        = "ECS"
      version         = "1"
      input_artifacts = ["MyAppBuild"]

      configuration {
        ClusterName = "${aws_ecs_cluster.ecs.name}"
        ServiceName = "${aws_ecs_service.ecs.name}"
      }
    }
  }

}
