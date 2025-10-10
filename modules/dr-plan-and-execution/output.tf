// Copyright (c) 2025, Oracle and/or its affiliates.
// Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl


output "dr_plan" {
  value = var.dr_plan == null ? null : oci_disaster_recovery_dr_plan.dr_plan[0]
}

output "dr_plan_execution" {
  value = var.dr_plan_execution == null ? null : oci_disaster_recovery_dr_plan_execution.dr_plan_execution[0]
}