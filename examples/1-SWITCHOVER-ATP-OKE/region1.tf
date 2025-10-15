// Copyright (c) 2025, Oracle and/or its affiliates.
// Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl


module "dr_protection_group_region1" {
  providers = {
    oci = oci.region1
  }
  source         = "oracle-terraform-modules/fsdr/oci//modules/dr-protection-group"
  compartment_id = yamldecode(file("${path.module}/region1.yaml"))["region1_dr_pg"]["compartment_id"]
  display_name   = yamldecode(file("${path.module}/region1.yaml"))["region1_dr_pg"]["display_name"]
  association = { role = yamldecode(file("${path.module}/region1.yaml"))["region1_dr_pg"]["association"]["role"]
    peer_region = yamldecode(file("${path.module}/region1.yaml"))["region1_dr_pg"]["association"]["peer_region"]
  peer_id = module.dr_protection_group_region2.dr_protection_group["id"] }
  log_location         = yamldecode(file("${path.module}/region1.yaml"))["region1_dr_pg"]["log_location"]
  members              = local.altered_primary_members
  disassociate_trigger = yamldecode(file("${path.module}/region1.yaml"))["region1_dr_pg"]["disassociate_trigger"]
}

module "dr_plan_region1" {
  count = yamldecode(file("${path.module}/execution.yaml"))["dr_plan_setup_on_region1"] == true ? 1 : 0
  providers = {
    oci = oci.region1
  }
  source = "oracle-terraform-modules/fsdr/oci//modules/dr-plan-and-execution"
  dr_plan = merge(yamldecode(file("${path.module}/region1.yaml"))["dr_plan_region1"],
    { dr_protection_group_id = module.dr_protection_group_region1.dr_protection_group["id"]
      refresh_trigger        = yamldecode(file("${path.module}/execution.yaml"))["region1_refresh_trigger"]
  verify_trigger = yamldecode(file("${path.module}/execution.yaml"))["region1_verify_trigger"] })
}

module "dr_plan_execution_region1" {
  providers = {
    oci = oci.region1
  }
  count  = yamldecode(file("${path.module}/execution.yaml"))["region1_plan_execution"]
  source = "oracle-terraform-modules/fsdr/oci//modules/dr-plan-and-execution"
  dr_plan_execution = merge(yamldecode(file("${path.module}/region1.yaml"))["dr_plan_execution_region1"],
  { plan_id = module.dr_plan_region1[0].dr_plan["id"] })
}
