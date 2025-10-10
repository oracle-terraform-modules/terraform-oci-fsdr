// Copyright (c) 2025, Oracle and/or its affiliates.
// Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl


resource "oci_disaster_recovery_dr_plan" "dr_plan" {
  count                  = var.dr_plan == null ? 0 : 1
  display_name           = var.dr_plan["display_name"]
  dr_protection_group_id = var.dr_plan["dr_protection_group_id"]
  type                   = var.dr_plan["type"]
  defined_tags           = var.dr_plan["defined_tags"]
  freeform_tags          = var.dr_plan["freeform_tags"]
  source_plan_id         = var.dr_plan["source_plan_id"]
  refresh_trigger        = var.dr_plan["refresh_trigger"]
  verify_trigger         = var.dr_plan["verify_trigger"]
}

resource "oci_disaster_recovery_dr_plan_execution" "dr_plan_execution" {
  count = var.dr_plan_execution == null ? 0 : 1
  execution_options {
    plan_execution_type   = var.dr_plan_execution["plan_execution_type"]
    are_prechecks_enabled = var.dr_plan_execution["are_prechecks_enabled"]
    are_warnings_ignored  = var.dr_plan_execution["are_warnings_ignored"]
  }
  plan_id       = try(oci_disaster_recovery_dr_plan.dr_plan[0].id, var.dr_plan_execution["plan_id"])
  defined_tags  = var.dr_plan_execution["defined_tags"]
  display_name  = var.dr_plan_execution["display_name"]
  freeform_tags = var.dr_plan_execution["freeform_tags"]
  timeouts {
    create = var.dr_plan_execution["timeouts_create"]
    update = var.dr_plan_execution["timeouts_update"]
  }
}