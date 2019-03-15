locals {
  common_tags = "${map(
    "Environment", "${var.environment}",
    "ManagedByTerraform", "true",
  )}"
}