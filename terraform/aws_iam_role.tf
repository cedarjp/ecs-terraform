# ecs instance
data "aws_iam_policy_document" "instance_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "instance_role_policy" {
  statement {
    actions = [
      "ecs:CreateCluster",
      "ecs:DeregisterContainerInstance",
      "ecs:DiscoverPollEndpoint",
      "ecs:Poll",
      "ecs:RegisterContainerInstance",
      "ecs:StartTelemetrySession",
      "ecs:UpdateContainerInstancesState",
      "ecs:Submit*",
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    effect    = "Allow"
    resources = ["*"]
  }
}

resource "aws_iam_role" "instance_role" {
  name               = "${var.name}-ecsInstanceRole"
  path               = "/"
  assume_role_policy = "${data.aws_iam_policy_document.instance_role.json}"
}

resource "aws_iam_instance_profile" "instance_role" {
  name = "${var.name}-ecsInstanceRole"
  role = "${aws_iam_role.instance_role.name}"
}

resource "aws_iam_role_policy" "instance_role" {
  role   = "${aws_iam_role.instance_role.id}"
  policy = "${data.aws_iam_policy_document.instance_role_policy.json}"
}

# ecs service role
data "aws_iam_policy_document" "ecs_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "ecs_role_policy" {
  statement {
    actions = [
      "ec2:AttachNetworkInterface",
      "ec2:CreateNetworkInterface",
      "ec2:CreateNetworkInterfacePermission",
      "ec2:DeleteNetworkInterface",
      "ec2:DeleteNetworkInterfacePermission",
      "ec2:Describe*",
      "ec2:DetachNetworkInterface",
      "elasticloadbalancing:DeregisterInstancesFromLoadBalancer",
      "elasticloadbalancing:DeregisterTargets",
      "elasticloadbalancing:Describe*",
      "elasticloadbalancing:RegisterInstancesWithLoadBalancer",
      "elasticloadbalancing:RegisterTargets",
      "route53:ChangeResourceRecordSets",
      "route53:CreateHealthCheck",
      "route53:DeleteHealthCheck",
      "route53:Get*",
      "route53:List*",
      "route53:UpdateHealthCheck",
      "servicediscovery:DeregisterInstance",
      "servicediscovery:Get*",
      "servicediscovery:List*",
      "servicediscovery:RegisterInstance",
      "servicediscovery:UpdateInstanceCustomHealthStatus",
    ]

    effect    = "Allow"
    resources = ["*"]
  }
}

resource "aws_iam_role" "ecs_role" {
  name               = "${var.name}-ecsServiceRole"
  path               = "/"
  assume_role_policy = "${data.aws_iam_policy_document.ecs_role.json}"
}

resource "aws_iam_role_policy" "ecs_role" {
  role   = "${aws_iam_role.ecs_role.id}"
  policy = "${data.aws_iam_policy_document.ecs_role_policy.json}"
}

# codebuild
data "aws_iam_policy_document" "codebuild" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "Service"
      identifiers = ["codebuild.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "codebuild_policy" {
  # CodeBuildTrustPolicy
  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    effect    = "Allow"
    resources = ["*"]
  }

  statement {
    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:GetObjectVersion",
    ]

    effect = "Allow"

    resources = [
      "${aws_s3_bucket.codepipeline.arn}",
      "${aws_s3_bucket.codepipeline.arn}/*",
    ]
  }

  statement {
    actions = [
      "ssm:GetParameters",
    ]

    effect    = "Allow"
    resources = ["*"]
  }

  # CodeBuildVPCTrustPolicy
  statement {
    actions = [
      "ec2:CreateNetworkInterface",
      "ec2:DescribeDhcpOptions",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DeleteNetworkInterface",
      "ec2:DescribeSubnets",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeVpcs",
    ]

    effect    = "Allow"
    resources = ["*"]
  }

  # EC2-Container-Registry
  statement {
    actions = [
      "ecr:CreateRepository",
      "ecr:GetAuthorizationToken",
    ]

    effect    = "Allow"
    resources = ["*"]
  }

  # EC2-Container-Service
  statement {
    actions = [
      "ecs:DiscoverPollEndpoint",
      "ecs:CreateCluster",
      "ecs:DeleteService",
      "ecs:DescribeTaskDefinition",
      "ecs:ListServices",
      "ecs:DeregisterTaskDefinition",
      "ecs:Poll",
      "ecs:UpdateService",
      "ecs:CreateService",
      "ecs:StartTelemetrySession",
      "ecs:ListTaskDefinitionFamilies",
      "ecs:RegisterTaskDefinition",
      "ecs:DescribeServices",
      "ecs:ListTaskDefinitions",
      "ecs:ListClusters",
    ]

    effect    = "Allow"
    resources = ["*"]
  }
}

resource "aws_iam_role" "codebuild" {
  name               = "${var.name}-CodeBuild"
  assume_role_policy = "${data.aws_iam_policy_document.codebuild.json}"
}

resource "aws_iam_role_policy" "codebuild" {
  role   = "${aws_iam_role.codebuild.id}"
  policy = "${data.aws_iam_policy_document.codebuild_policy.json}"
}

# codepipeline
data "aws_iam_policy_document" "codepipeline" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "Service"
      identifiers = ["codepipeline.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "codepipeline_policy" {
  statement {
    actions = [
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:GetBucketVersioning",
      "s3:PutObject",
      "codecommit:CancelUploadArchive",
      "codecommit:GetBranch",
      "codecommit:GetCommit",
      "codecommit:GetUploadArchiveStatus",
      "codecommit:UploadArchive",
      "codedeploy:CreateDeployment",
      "codedeploy:GetApplicationRevision",
      "codedeploy:GetDeployment",
      "codedeploy:GetDeploymentConfig",
      "codedeploy:RegisterApplicationRevision",
      "autoscaling:*",
      "cloudwatch:*",
      "s3:*",
      "sns:*",
      "cloudformation:*",
      "rds:*",
      "sqs:*",
      "ecs:*",
      "iam:PassRole",
      "lambda:InvokeFunction",
      "lambda:ListFunctions",
      "opsworks:CreateDeployment",
      "opsworks:DescribeApps",
      "opsworks:DescribeCommands",
      "opsworks:DescribeDeployments",
      "opsworks:DescribeInstances",
      "opsworks:DescribeStacks",
      "opsworks:UpdateApp",
      "opsworks:UpdateStack",
      "cloudformation:CreateStack",
      "cloudformation:DeleteStack",
      "cloudformation:DescribeStacks",
      "cloudformation:UpdateStack",
      "cloudformation:CreateChangeSet",
      "cloudformation:DeleteChangeSet",
      "cloudformation:DescribeChangeSet",
      "cloudformation:ExecuteChangeSet",
      "cloudformation:SetStackPolicy",
      "cloudformation:ValidateTemplate",
      "iam:PassRole",
      "codebuild:BatchGetBuilds",
      "codebuild:StartBuild",
    ]

    effect    = "Allow"
    resources = ["*"]
  }
}

resource "aws_iam_role" "codepipeline" {
  name               = "${var.name}-CodePipeline"
  assume_role_policy = "${data.aws_iam_policy_document.codepipeline.json}"
}

resource "aws_iam_role_policy" "codepipeline" {
  role   = "${aws_iam_role.codepipeline.id}"
  policy = "${data.aws_iam_policy_document.codepipeline_policy.json}"
}

# rds
data "aws_iam_policy_document" "rds" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["monitoring.rds.amazonaws.com"]
    }

    effect = "Allow"
  }
}

resource "aws_iam_role" "rds" {
  name = "${var.db_name}_rds_monitoring"
  path = "/"

  assume_role_policy = "${data.aws_iam_policy_document.rds.json}"
}

resource "aws_iam_role_policy_attachment" "monitoring" {
  role       = "${aws_iam_role.rds.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}

# ecs target
data "aws_iam_policy_document" "ecs_target_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs.application-autoscaling.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "ecs_target_role_policy" {
  statement {
    actions = [
      "ecs:DescribeServices",
      "ecs:UpdateService",
      "cloudwatch:PutMetricAlarm",
      "cloudwatch:DescribeAlarms",
      "cloudwatch:DeleteAlarms",
    ]

    effect    = "Allow"
    resources = ["*"]
  }
}

resource "aws_iam_role" "ecs_target" {
  name               = "${var.name}-ecsTarget"
  path               = "/"
  assume_role_policy = "${data.aws_iam_policy_document.ecs_target_role.json}"
}

resource "aws_iam_role_policy" "ecs_target" {
  role   = "${aws_iam_role.ecs_target.id}"
  policy = "${data.aws_iam_policy_document.ecs_target_role_policy.json}"
}

# transcoder
data "aws_iam_policy_document" "transcoder_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["elastictranscoder.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "transcoder_role_policy" {
  statement {
    actions = [
      "s3:Put*",
      "s3:ListBucket",
      "s3:*MultipartUpload*",
      "s3:Get*",
      "s3:*Delete*",
      "s3:*Policy*",
      "sns:Publish",
      "sns:*Remove*",
      "sns:*Delete*",
      "sns:*Permission*"
    ]

    effect    = "Allow"
    resources = ["*"]
  }
}

resource "aws_iam_role" "transcoder" {
  name               = "${var.name}-TranscoderRole"
  path               = "/"
  assume_role_policy = "${data.aws_iam_policy_document.transcoder_role.json}"
}

resource "aws_iam_role_policy" "transcoder" {
  role   = "${aws_iam_role.transcoder.id}"
  policy = "${data.aws_iam_policy_document.transcoder_role_policy.json}"
}

# lambda_function
data "aws_iam_policy_document" "lambda_function_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "lambda_function_role_policy" {
  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "elastictranscoder:Read*",
      "elastictranscoder:List*",
      "elastictranscoder:*Job",
      "elastictranscoder:*Preset",
      "s3:ListAllMyBuckets",
      "s3:ListBucket",
      "s3:ListObjects",
      "s3:DeleteObject",
      "iam:ListRoles",
      "sns:ListTopics"
    ]

    effect    = "Allow"
    resources = ["*"]
  }
}

resource "aws_iam_role" "lambda_funciton" {
  name               = "${var.name}-LambdaFunctionRole"
  path               = "/"
  assume_role_policy = "${data.aws_iam_policy_document.lambda_function_role.json}"
}

resource "aws_iam_role_policy" "lambda_funciton" {
  role   = "${aws_iam_role.lambda_funciton.id}"
  policy = "${data.aws_iam_policy_document.lambda_function_role_policy.json}"
}

# codedeploy
data "aws_iam_policy_document" "codedeploy_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["codedeploy.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "codedeploy_role_policy" {
  statement {
    actions = [
      "autoscaling:CompleteLifecycleAction",
      "autoscaling:DeleteLifecycleHook",
      "autoscaling:DescribeAutoScalingGroups",
      "autoscaling:DescribeLifecycleHooks",
      "autoscaling:PutLifecycleHook",
      "autoscaling:RecordLifecycleActionHeartbeat",
      "ec2:DescribeInstances",
      "ec2:DescribeInstanceStatus",
      "tag:GetTags",
      "tag:GetResources"
    ]

    effect    = "Allow"
    resources = ["*"]
  }
}

resource "aws_iam_role" "codedeploy" {
  name               = "${var.name}-CodeDeployRole"
  path               = "/"
  assume_role_policy = "${data.aws_iam_policy_document.codedeploy_role.json}"
}

resource "aws_iam_role_policy" "codedeploy" {
  role   = "${aws_iam_role.codedeploy.id}"
  policy = "${data.aws_iam_policy_document.codedeploy_role_policy.json}"
}

# ec2 cron
data "aws_iam_policy_document" "ec2_cron_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "ec2_cron_role_policy" {
  statement {
    actions = [
      "s3:Get*",
      "s3:List*"
    ]

    effect    = "Allow"
    resources = ["*"]
  }
}

resource "aws_iam_role" "ec2_cron" {
  name               = "${var.name}-EC2CronRole"
  path               = "/"
  assume_role_policy = "${data.aws_iam_policy_document.ec2_cron_role.json}"
}

resource "aws_iam_role_policy" "ec2_cron" {
  role   = "${aws_iam_role.ec2_cron.id}"
  name   = "${var.name}-EC2CronRolePolicy"
  policy = "${data.aws_iam_policy_document.ec2_cron_role_policy.json}"
}

resource "aws_iam_instance_profile" "ec2_cron" {
  name = "${var.name}-EC2CronInstanceProfile"
  role = "${aws_iam_role.ec2_cron.name}"
}
