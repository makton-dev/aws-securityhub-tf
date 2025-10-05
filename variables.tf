#############################################################
# Variables for the Project
#############################################################
variable "project" {
  type = string
  description = "Name of project. Will be used in tags and naming of resources"
}

# Leave this default for now as multi-regions are not fully setup just yet
variable "multi_regions" {
  type = string
  description = "sets what the aggregator will do. setting to NO_REGIONS only does the main region https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/securityhub_finding_aggregator."
  default = "NO_REGIONS"
}

# For Future use with Multi regions
variable "additional_regions" {
  type = list(string)
  description = "By default the aggregator only works on the the provider's region. this allows other regions to be monitored. default is []"
  default = []
}

variable "security_subscriptions" {
  type = list(string)
  description = "Lisa of security subscriptions for the security Hub https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/securityhub_standards_subscription"
  default = [
    "pci-dss/v/4.0.1",
    "cis-aws-foundations-benchmark/v/3.0.0",
    "aws-foundational-security-best-practices/v/1.0.0"
  ]
}