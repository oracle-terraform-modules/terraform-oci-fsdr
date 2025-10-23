// Copyright (c) 2025, Oracle and/or its affiliates.
// Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl


module "dr_protection_group_region2" {
  providers = {
    oci = oci.region2
  }
  source               = "./modules/dr-protection-group"
  compartment_id       = var.region2_config["compartment_id"]
  display_name         = var.region2_config["protection_group_display_name"]
  defined_tags         = var.region2_config["defined_tags"]
  disassociate_trigger = var.region2_config["disassociate_trigger"]
  freeform_tags        = var.region2_config["freeform_tags"]
  log_location         = var.region2_config["log_location"]
  members              = local.region2_altered_members
}

module "dr_plan_region2" {
  providers = {
    oci = oci.region2
  }
  for_each = { for entry in var.region2_config["dr_plan_and_execution"] : entry.plan_display_name => entry }
  source   = "./modules/dr-plan-and-execution"
  dr_plan = {
    display_name           = each.value["plan_display_name"]
    dr_protection_group_id = module.dr_protection_group_region2.dr_protection_group["id"]
    type                   = each.value["type"]
    defined_tags           = each.value["defined_tags"]
    freeform_tags          = each.value["freeform_tags"]
    source_plan_id         = each.value["source_plan_id"]
    refresh_trigger        = each.value["refresh_trigger"]
    verify_trigger         = each.value["verify_trigger"]
  }
}

locals {
  region2_plan_execution = flatten([for entry in var.region2_config["dr_plan_and_execution"] : [for key in entry.plan_execution : {
    index                  = "${entry.plan_display_name}=>${key.execution_display_name}"
    execution_display_name = key.execution_display_name
    plan_execution_type    = key.plan_execution_type
    are_prechecks_enabled  = key.are_prechecks_enabled
    are_warnings_ignored   = key.are_warnings_ignored
    plan_id                = entry.plan_display_name
    defined_tags           = key.defined_tags
    freeform_tags          = key.freeform_tags
    timeouts_create        = key.timeouts_create
    timeouts_update        = key.timeouts_update
  }]])


}

module "dr_plan_execution_region2" {
  providers = {
    oci = oci.region2
  }
  for_each = { for entry in local.region2_plan_execution : entry.index => entry }
  source   = "./modules/dr-plan-and-execution"
  dr_plan_execution = {
    plan_execution_type   = each.value["plan_execution_type"]
    are_prechecks_enabled = each.value["are_prechecks_enabled"]
    are_warnings_ignored  = each.value["are_warnings_ignored"]
    plan_id               = module.dr_plan_region2[each.value["plan_id"]].dr_plan["id"]
    defined_tags          = each.value["defined_tags"]
    display_name          = each.value["execution_display_name"]
    freeform_tags         = each.value["freeform_tags"]
    timeouts_create       = each.value["timeouts_create"]
    timeouts_update       = each.value["timeouts_update"]
  }
}
