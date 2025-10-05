#############################################################
# set up the AWS Config Recorder
#############################################################

resource "aws_config_configuration_recorder" "config_recorder" {
  name     = "${var.project}-recorder"
  role_arn = aws_iam_service_linked_role.config_role.arn

  recording_group {
    all_supported                 = true
    include_global_resource_types = true
  }

  recording_mode {
    recording_frequency = "CONTINUOUS"
  }

  depends_on = [ aws_s3_bucket_policy.config_logging_policy ]
}

# S3 bucket will be the channel
resource "aws_config_delivery_channel" "config_channel" {
  name = "${var.project}-config-channel"
  s3_bucket_name = aws_s3_bucket.config_bucket.id
  
  depends_on     = [ aws_config_configuration_recorder.config_recorder ]
}

resource "aws_config_configuration_recorder_status" "config_recorder_status" {
  name       = aws_config_configuration_recorder.config_recorder.name
  is_enabled = true
  depends_on = [aws_config_delivery_channel.config_channel]
}
