// Copyright (c) 2025, Oracle and/or its affiliates.
// Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl


output "region1_members" {
  value       = local.region1_members_after_structure
  description = "Members of the existing protection group in region1"
}

output "region2_members" {
  value       = local.region2_members_after_structure
  description = "Members of the existing protection group in region2"
}

output "region1_dr_protection_group_id" {
  value       = module.dr_protection_group_region1.dr_protection_group.id
  description = "Protection group OCID of region1"
}

output "region2_dr_protection_group_id" {
  value       = module.dr_protection_group_region2.dr_protection_group.id
  description = "Protection group OCID of region2"
}

output "region1_plan_ids" {
  value       = { for entry in var.region1_config["dr_plan_and_execution"] : entry["plan_display_name"] => module.dr_plan_region1[entry["plan_display_name"]].dr_plan["id"] }
  description = "OCID of region1 plans"
}

output "region2_plan_ids" {
  value       = { for entry in var.region2_config["dr_plan_and_execution"] : entry["plan_display_name"] => module.dr_plan_region2[entry["plan_display_name"]].dr_plan["id"] }
  description = "OCID of region2 plans"
}
