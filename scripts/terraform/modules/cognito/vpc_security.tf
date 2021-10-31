resource "aws_security_group" "allow_lambda" {
  name        = "${var.null_label_prefix}-lambda-security-group"
  description = "Allow traffic to the lambda functions"
  vpc_id      = data.terraform_remote_state.platform.outputs.vpc_id

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.null_label_tags
}
