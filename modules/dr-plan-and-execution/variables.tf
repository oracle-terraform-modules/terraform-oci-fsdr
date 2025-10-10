// Copyright (c) 2025, Oracle and/or its affiliates.
// Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl


variable "dr_plan" {
  type = object({
    display_name           = string
    dr_protection_group_id = string
    type                   = string
    defined_tags           = optional(map(string), null)
    freeform_tags          = optional(map(string), null)
    source_plan_id         = optional(string, null)
    refresh_trigger        = optional(number, null)
    verify_trigger         = optional(number, null)
  })
  default = null
}

variable "dr_plan_execution" {
  type = object({
    plan_execution_type   = string
    are_prechecks_enabled = optional(bool, false)
    are_warnings_ignored  = optional(bool, false)
    plan_id               = optional(string, null)
    defined_tags          = optional(map(string), null)
    display_name          = optional(string, null)
    freeform_tags         = optional(map(string), null)
    timeouts_create       = optional(string, "20m")
    timeouts_update       = optional(string, "20m")
  })
  default = null
}