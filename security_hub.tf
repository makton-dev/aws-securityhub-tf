#############################################################
# Enable the AWS Security hub 
#############################################################
resource "aws_securityhub_account" "hub" {
  enable_default_standards = false

  depends_on = [aws_config_configuration_recorder_status.config_recorder_status]
}

resource "time_sleep" "hub_enable_wait" {
  create_duration = "10s"

  depends_on = [aws_securityhub_account.hub]
}

resource "aws_securityhub_finding_aggregator" "hub_findings" {
  linking_mode = var.multi_regions
  ## Can add other regions but would need to do more work to have them function here.
  # specified_regions = var.additional_regions 

  depends_on = [time_sleep.hub_enable_wait]
}

# Enable the subscriptions for the Security Hub
resource "aws_securityhub_standards_subscription" "hub_subs" {
  for_each      = toset(var.security_subscriptions)
  standards_arn = "arn:aws:securityhub:${data.aws_region.current.region}::standards/${each.value}"

  depends_on = [time_sleep.hub_enable_wait]
}
