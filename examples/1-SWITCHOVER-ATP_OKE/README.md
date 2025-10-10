# 1-SWITCHOVER-ATP_OKE

This module is an opinionated approach of creating DR protection group, plan and execution to conduct SWITCHOVER activity.

## NOTE:
This example is for adding ATP DB's and OKE clusters alone.

## STEPS TO FOLLOW:

Step1: Clone the repository and navigate to examples/1-SWITCHOVER-ATP_OKE.

Step2: In the providers.tf, specify the region1 and region2 region. EX: "us-phoenix-1" and "eu-frankfurt-1".

Step3: If you chose to use "SECURITY_TOKEN" as auth method , please do "oci session authenticate" for region1 and region2 region and have it in separate profile. EX: PHX and FRA.

```
bash
oci session authenticate
```

Step4: On the region1.yaml and region2.yaml ,under region1_dr_pg and region2_dr_pg update the compartment ocid, Autonomous Database details and OKE details(namespace which needs to be switchovered).

Step5: Initialize the terraform,

```
bash
terraform init
```

Step6: Verify the plan

```
bash
terraform plan
```

Step7: Apply the changes, this will create the DR protection group in both region1 and region2, associate region2(standby) protection group to region1(primary)

```
bash
terraform apply -auto-approve
```

Step8: Change the dr_plan_setup_on_region2 option in execution.yaml as 'true', Run terraform apply. This will create a built in default dr plan for the members added in the region2.

Step9: Increment the value of 'region2_plan_execution' to '1' in execution.yaml, Run terraform apply. This will start the execution of SWITCHOVER in the region2. SWITCHOVER happened from REGION1 to REGION2

Step10: Now to start the SWITCHOVER from REGION2 to REGION1, change the execution.yaml as below

```
yaml
dr_plan_setup_on_region1: true
dr_plan_setup_on_region2: true

Region_of_execution: REGION1
```

Run terraform apply. This will create DR plan in the Region1.

Step11: Increment the value of 'region1_plan_execution' to '1', Run terraform apply. This will start the execution of SWITCHOVER in the region1. 



Going forward with the continuous SWITCHOVER, please change below value alone

```
yaml
Region_of_execution: REGION1

region1_refresh_trigger: 0
region1_verify_trigger: 0
region1_plan_execution: 0

region2_refresh_trigger: 0
region2_verify_trigger: 0
region2_plan_execution: 0
```

For refresh and verify the plan, please increment the trigger values according. Best practice is to first increment the refresh trigger, then followed by verify trigger.


Step12: To destroy, increment the 'disassociate_trigger: 1' in region1.yaml for the actual primary group. Run terraform apply, this will disassociate teh standby protection group from primary.

Step13: Run terraform destroy.


## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_oci"></a> [oci](#requirement\_oci) | >= 5.0.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_dr_plan_execution_region1"></a> [dr\_plan\_execution\_region1](#module\_dr\_plan\_execution\_region1) | oracle-terraform-modules/fsdr/oci//modules/dr-plan-and-execution | n/a |
| <a name="module_dr_plan_execution_region2"></a> [dr\_plan\_execution\_region2](#module\_dr\_plan\_execution\_region2) | oracle-terraform-modules/fsdr/oci//modules/dr-plan-and-execution | n/a |
| <a name="module_dr_plan_region1"></a> [dr\_plan\_region1](#module\_dr\_plan\_region1) | oracle-terraform-modules/fsdr/oci//modules/dr-plan-and-execution | n/a |
| <a name="module_dr_plan_region2"></a> [dr\_plan\_region2](#module\_dr\_plan\_region2) | oracle-terraform-modules/fsdr/oci//modules/dr-plan-and-execution | n/a |
| <a name="module_dr_protection_group_region1"></a> [dr\_protection\_group\_region1](#module\_dr\_protection\_group\_region1) | oracle-terraform-modules/fsdr/oci//modules/dr-protection-group | n/a |
| <a name="module_dr_protection_group_region2"></a> [dr\_protection\_group\_region2](#module\_dr\_protection\_group\_region2) | oracle-terraform-modules/fsdr/oci//modules/dr-protection-group | n/a |


