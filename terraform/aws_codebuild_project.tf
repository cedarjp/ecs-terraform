resource "aws_codebuild_project" "app" {
  name          = "${var.name}"
  description   = "${var.name}_codebuild_project"
  build_timeout = "${var.cb_build_timeout}"
  service_role  = "${aws_iam_role.codebuild.arn}"

  artifacts {
    type     = "CODEPIPELINE"
    location = "CODEPIPELINE"
  }

  cache {
    type = "NO_CACHE"
  }

  environment {
    compute_type    = "BUILD_GENERAL1_SMALL"
    image           = "aws/codebuild/docker:17.09.0"
    type            = "LINUX_CONTAINER"
    privileged_mode = true

    environment_variable {
      "name"  = "AWS_DEFAULT_REGION"
      "value" = "${var.region}"
    }

    environment_variable {
      "name"  = "IMAGE_NAME"
      "value" = "${aws_ecr_repository.uwsgi.name}"
    }

    environment_variable {
      "name"  = "IMAGE_NAME_NGINX"
      "value" = "${aws_ecr_repository.nginx.name}"
    }

    environment_variable {
      "name"  = "AWS_ACCOUNT_ID"
      "value" = "${data.aws_caller_identity.self.account_id}"
    }
  }

  source {
    type = "CODEPIPELINE"
  }
}
