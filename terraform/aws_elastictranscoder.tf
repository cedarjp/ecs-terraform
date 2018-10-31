resource "aws_elastictranscoder_pipeline" "transcoder" {
  input_bucket     = "${aws_s3_bucket.video_input.bucket}"
  name             = "${var.name}_elastictranscoder_pipeline"
  role             = "${aws_iam_role.transcoder.arn}"

  content_config   = {
    bucket         = "${aws_s3_bucket.video_stream.bucket}"
    storage_class  = "Standard"
  }

  thumbnail_config = {
    bucket         = "${aws_s3_bucket.video_thumb.bucket}"
    storage_class  = "Standard"
  }

  content_config_permissions = {
    grantee_type = "Group"
    grantee = "AllUsers"
    access = ["Read"]
  }

  thumbnail_config_permissions = {
    grantee_type = "Group"
    grantee = "AllUsers"
    access = ["Read"]
  }
}
