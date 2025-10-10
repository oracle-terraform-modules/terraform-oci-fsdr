// Copyright (c) 2025, Oracle and/or its affiliates.
// Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl


module "dr_protection_group_region2" {
  providers = {
    oci = oci.region2
  }
  source         = "../../modules/dr_protection_group"
  compartment_id = yamldecode(file("${path.module}/region2.yaml"))["region2_dr_pg"]["compartment_id"]
  display_name   = yamldecode(file("${path.module}/region2.yaml"))["region2_dr_pg"]["display_name"]
  log_location   = yamldecode(file("${path.module}/region2.yaml"))["region2_dr_pg"]["log_location"]
  members        = local.altered_standby_members
}

module "dr_plan_region2" {
  count = yamldecode(file("${path.module}/execution.yaml"))["dr_plan_setup_on_region2"] == true ? 1 : 0
  providers = {
    oci = oci.region2
  }
  source = "../../modules/dr_plan_and_execution"
  dr_plan = merge(yamldecode(file("${path.module}/region2.yaml"))["dr_plan_region2"],
    { dr_protection_group_id = module.dr_protection_group_region2.dr_protection_group["id"]
      refresh_trigger        = yamldecode(file("${path.module}/execution.yaml"))["region2_refresh_trigger"]
  verify_trigger = yamldecode(file("${path.module}/execution.yaml"))["region2_verify_trigger"] })
}

module "dr_plan_execution_region2" {
  providers = {
    oci = oci.region2
  }
  count  = yamldecode(file("${path.module}/execution.yaml"))["region2_plan_execution"]
  source = "../../modules/dr_plan_and_execution"
  dr_plan_execution = merge(yamldecode(file("${path.module}/region2.yaml"))["dr_plan_execution_region2"],
  { plan_id = module.dr_plan_region2[0].dr_plan["id"] })
}
