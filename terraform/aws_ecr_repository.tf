data "aws_iam_policy_document" "ecr_policy" {
  statement {
    actions = [
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:BatchCheckLayerAvailability",
      "ecr:PutImage",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload",
      "ecr:DescribeRepositories",
      "ecr:GetRepositoryPolicy",
      "ecr:ListImages",
      "ecr:DeleteRepository",
      "ecr:BatchDeleteImage",
      "ecr:SetRepositoryPolicy",
      "ecr:DeleteRepositoryPolicy"
    ]
    effect    = "Allow"
//    resources = ["*"]

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
  }
}


resource "aws_ecr_repository" "uwsgi" {
  name = "uwsgi"
}

resource "aws_ecr_repository_policy" "uwsgi" {
  repository = "${aws_ecr_repository.uwsgi.name}"
  policy = "${data.aws_iam_policy_document.ecr_policy.json}"
}

resource "aws_ecr_repository" "nginx" {
  name = "nginx"
}

resource "aws_ecr_repository_policy" "nginx" {
  repository = "${aws_ecr_repository.nginx.name}"
  policy = "${data.aws_iam_policy_document.ecr_policy.json}"
}
