# Terraform module for DR Plan and Execution

This terraform module is for creating dr plan and execution resource.

## Sample

```hcl
module "dr_plan" {
  source = "oracle-terraform-modules/fsdr/oci//modules/dr-plan-and-execution"
  dr_plan = {
        display_name           = "Switchover_plan"
    dr_protection_group_id = "<ocid of DR PG>"
    type                   = "SWITCHOVER"
  }
}

module "dr_plan_execution" {
  source = "oracle-terraform-modules/fsdr/oci//modules/dr-plan-and-execution"
  dr_plan_execution = {
    plan_id = module.dr_plan.dr_plan["id"]
    plan_execution_type   = "SWITCHOVER"
  }
}
```



## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_oci"></a> [oci](#requirement\_oci) | >= 5.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_oci"></a> [oci](#provider\_oci) | >= 5.0.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [oci_disaster_recovery_dr_plan.dr_plan](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/disaster_recovery_dr_plan) | resource |
| [oci_disaster_recovery_dr_plan_execution.dr_plan_execution](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/disaster_recovery_dr_plan_execution) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_dr_plan"></a> [dr\_plan](#input\_dr\_plan) | n/a | <pre>object({<br/>        display_name = string<br/>    dr_protection_group_id = string<br/>    type = string<br/>    defined_tags = optional(map(string), null)<br/>    freeform_tags = optional(map(string), null)<br/>    source_plan_id = optional(string, null)<br/>    refresh_trigger = optional(number, null)<br/>    verify_trigger = optional(number, null)<br/>  })</pre> | `null` | no |
| <a name="input_dr_plan_execution"></a> [dr\_plan\_execution](#input\_dr\_plan\_execution) | n/a | <pre>object({<br/>    plan_execution_type = string<br/>        are_prechecks_enabled = optional(bool, false)<br/>        are_warnings_ignored = optional(bool, false)<br/>    plan_id = optional(string, null)<br/>    defined_tags = optional(map(string), null)<br/>    display_name = optional(string, null)<br/>    freeform_tags = optional(map(string), null)<br/>    timeouts_create = optional(string, "20m")<br/>    timeouts_update = optional(string, "20m")<br/>  })</pre> | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dr_plan"></a> [dr\_plan](#output\_dr\_plan) | n/a |
| <a name="output_dr_plan_execution"></a> [dr\_plan\_execution](#output\_dr\_plan\_execution) | n/a |
