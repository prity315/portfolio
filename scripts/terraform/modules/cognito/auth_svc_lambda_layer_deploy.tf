data "archive_file" "auth_svc_lambda_layer" {
  type        = "zip"
  source_dir  = "../lambda/auth-svc-layer"
  output_path = "zipFiles/authSvcLayer.zip"
}

resource "aws_lambda_layer_version" "auth_svc_lambda_layer" {
  filename            = data.archive_file.auth_svc_lambda_layer.output_path
  layer_name          = "${var.null_label_prefix}-authSvcLayer"
  source_code_hash    = data.archive_file.auth_svc_lambda_layer.output_base64sha256
  compatible_runtimes = ["nodejs12.x"] //lambda layer runtime
}
