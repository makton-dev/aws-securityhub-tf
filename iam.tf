#############################################################
# IAM Service Role for the AWS Config recorder
#############################################################
resource "aws_iam_service_linked_role" "config_role" {
  aws_service_name = "config.amazonaws.com"

  tags = {
    Name = "${var.project}-config-role"
  }
}
