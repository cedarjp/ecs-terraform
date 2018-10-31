resource "aws_s3_bucket" "codepipeline" {
  bucket = "${var.codepipeline_s3_bucket_name}"
  acl    = "private"
}

data "template_file" "alb_log_s3_policy" {
  template = "${file("${path.module}/templates/alb_log_s3_policy.json")}"

  vars {
    cluster_name = "${aws_ecs_cluster.ecs.name}"
    alb_log_s3_bucket_name = "${var.alb_log_s3_bucket_name}"
    aws_elb_service_account_arn = "${data.aws_elb_service_account.alb.arn}"
  }
}

resource "aws_s3_bucket" "alb_log" {
  bucket = "${var.alb_log_s3_bucket_name}"
  acl    = "private"

  policy = "${data.template_file.alb_log_s3_policy.rendered}"
}

resource "aws_s3_bucket" "video_input" {
  bucket = "${var.name}-video-input"
  acl    = "private"
}

resource "aws_s3_bucket" "video_thumb" {
  bucket = "${var.name}-video-thumb"
  acl    = "private"
}

resource "aws_s3_bucket" "video_stream" {
  bucket = "${var.name}-video-stream"
  acl    = "private"
}

resource "aws_s3_bucket_notification" "video_input" {
  bucket = "${aws_s3_bucket.video_input.id}"

  lambda_function {
    lambda_function_arn = "${aws_lambda_function.lambda.arn}"
    events              = ["s3:ObjectCreated:Put", "s3:ObjectCreated:CompleteMultipartUpload"]
  }
}

resource "aws_s3_bucket" "codedeploy" {
  bucket = "${var.name}-deploy-bucket"
  acl= "private"
  tags {
    Name = "${var.name}-deploy-bucket"
  }
  versioning {
    enabled = true
  }
}
