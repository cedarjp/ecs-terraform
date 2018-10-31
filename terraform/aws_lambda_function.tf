data "template_file" "lambda" {
  template = "${file("${path.module}/templates/lambda_function.py")}"

  vars {
    pipeline_id= "${aws_elastictranscoder_pipeline.transcoder.id}"
  }
}

data "archive_file" "lambda" {
  type        = "zip"
  output_path = "lambda/lambda_function.zip"
  source {
    content = "${data.template_file.lambda.rendered}"
    filename = "lambda_function.py"
  }
}

resource "aws_lambda_function" "lambda" {
  function_name = "runTranscoderPipeline"
  handler = "lambda_function.lambda_handler"
  role = "${aws_iam_role.lambda_funciton.arn}"
  runtime = "python3.6"
  filename = "${data.archive_file.lambda.output_path}"
  source_code_hash = "${data.archive_file.lambda.output_base64sha256}"
}

resource "aws_lambda_permission" "lambda" {
  action = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.lambda.function_name}"
  principal = "s3.amazonaws.com"
  source_arn = "${aws_s3_bucket.video_input.arn}"
}