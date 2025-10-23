# OCI Full Stack Disaster Recovery - Terraform Module

This Terraform module sets up the OCI Full Stack DR configuration between two OCI regions. It handles everything from creating protection groups to running DR plans.

## What it does

The module automates the entire Full Stack DR setup process:

- Creates DR protection groups (DRPG) in both regions
- Adds your resources as members to each DRPG
- Sets up the right roles and associations
- Creates switchover plan
- Executes the switchover plan

You can also modify, add, or remove members as needed. The terraform module intelligently validates members directly from the DR protection groups to manage new resource creation—such as moving compute resources—during DR plan execution. However, any failures encountered during plan execution must be handled outside of Terraform. There is no option to add user-defined plan groups as of today.

## Example Setup

In this example to start with, we're protecting these resources:

**Region 1 DRPG:**
- Autonomous AI Database (Primary)
- OKE Cluster (Primary)
- Moving Compute instance
- Volume group 

**Region 2 DRPG:**
- Autonomous AI Database (Standby)
- OKE Cluster (Standby)

## How to use it

**Step 1: Configure your regions and authetication method**

Open `providers.tf` and update it with your region identifiers and authentication method.

For this example:
- Region 1: Your primary region (e.g., Ashburn)
- Region 2: Your standby region (e.g., Phoenix)

For this example:

- Region 1:
  - auth                = "SecurityToken"
  - config_file_profile = "IAD"
- Region 2:
  - auth                = "SecurityToken"
  - config_file_profile = "PHX"

**Step 2: Initialize Terraform**

```bash
terraform init
```

**Step 3: Update Region yaml files** 

1. Update the region1.yaml(primary) and region2.yaml(standby) with necesary configuration.  The configuration is provided with the minimum requirements, you must modify the required properties according to your requirements.

2. In "region1.yaml" file remove the empty set [] of add_members and add the members to the primary. You must update the values of your configuration. 

```yaml
add_members: 
 - autonomous_database_standby_type_for_dr_drills: "SNAPSHOT_STANDBY"
   member_id: "ocid1.autonomousdatabase.oc1.iad.xxxx" # update the atp db ocid
   member_type: "AUTONOMOUS_DATABASE"
 - member_id: "ocid1.cluster.oc1.iad.xxxx" # update the oke ocid
   member_type: "OKE_CLUSTER"
   peer_cluster_id: "ocid1.cluster.oc1.phx.yyyy" # update the peer oke ocid
   backup_location:
     bucket: "oke-backup-iad" # create and update the bucket name
     namespace: "xxxx" # update the bucket namespace
   backup_config:
     backup_schedule: "FREQ=HOURLY;BYHOUR=0;BYMINUTE=0;INTERVAL=1"
     exclude_namespaces: []
     image_replication_vault_secret_id: null
     max_number_of_backups_retained: 3
     namespaces: ["ns1", "ns2"] # update the list of kubernetes namespace
     replicate_images: "ENABLE"
 - member_id: ocid1.volumegroup.oc1.iad.xxxx # update the volume group ocid
   member_type: VOLUME_GROUP
 - member_id: "ocid1.instance.oc1.iad.xxxx" # update the compute instance ocid
   member_type: "COMPUTE_INSTANCE_MOVABLE"
   vnic_mapping: []
   vnic_mappings:
    - destination_nsg_id_list: []
      destination_primary_private_ip_address: ""
      destination_primary_private_ip_hostname_label: ""
      destination_reserved_public_ip_id: ""
      destination_subnet_id: "ocid1.subnet.oc1.phx.yyyy " # update the destination subnet ocid
      source_vnic_id: "ocid1.vnic.oc1.iad.xxxx" # update the source vnic ocid
```

3. In "region2.yaml" file remove the empty set [] of add_members and add the members to the standby.You must update the values of your configuration. 

```yaml
add_members: 
    - autonomous_database_standby_type_for_dr_drills: "REFRESHABLE_CLONE"
      member_id: "ocid1.autonomousdatabase.oc1.phx.yyyy" # update the atp db ocid
      member_type: "AUTONOMOUS_DATABASE"
    - member_id: "ocid1.cluster.oc1.phx.yyyy"  # update the oke ocid
      member_type: "OKE_CLUSTER"
      peer_cluster_id: "ocid1.cluster.oc1.iad.xxxx" # update the peer oke ocid
      backup_location:
        bucket: "oke-backup-phx" # update the bucket name
        namespace: "xxxx" # update the bucket namespace
      backup_config:
        backup_schedule: "FREQ=HOURLY;BYHOUR=0;BYMINUTE=0;INTERVAL=1"
        exclude_namespaces: []
        image_replication_vault_secret_id: null
        max_number_of_backups_retained: 3
        namespaces: ["ns1", "ns2"] # update the list of kubernetes namespace
        replicate_images: "ENABLE"
```


**Step 4: Apply the configuration for creating DR protection groups, association roles and adding members to it**

```bash
terraform plan
```

```bash
terraform apply
```


**Step5: To create DR plan in standby(region2) and run terraform apply** 

Full Stack DR allows to create DR plans only in the protection group which has "Standby role", hence you must first create the DR plan in the region 2.Update the region2.yaml as below.

```yaml
dr_plan_and_execution:
- plan_display_name: SWITCHOVER-TO-PHOENIX
  type: SWITCHOVER
  refresh_trigger: null
  verify_trigger: null
  plan_execution: []
```
You can also create other supported plans like Failover and DR drills. In this example we will use Switchover plan. Once updated, run terraform apply. 

```bash
terraform apply
```

**Step 6: To execute DR plans in standby(region2) and run terraform apply** 

It is highly recommended to first run the switchover prechecks and verify for successful execution. Update the region2.yaml as below to run the switchover prechecks. Run terraform apply. 


region2.yaml
```yaml
dr_plan_and_execution:
- plan_display_name: SWITCHOVER-TO-PHOENIX
  type: SWITCHOVER
  refresh_trigger: null
  verify_trigger: null
  plan_execution:
  - execution_display_name: SWITCHOVER-1-PRECHECK
    plan_execution_type: SWITCHOVER_PRECHECK
    timeouts_create: 60m
    are_prechecks_enabled: false
```

```bash
terraform apply
``` 

pdate the region2.yaml as below to run the switchover plan. Run terraform apply. 

region2.yaml
```yaml
dr_plan_and_execution:
- plan_display_name: SWITCHOVER-TO-PHOENIX
  type: SWITCHOVER
  refresh_trigger: null
  verify_trigger: null
  plan_execution:
  # - execution_display_name: SWITCHOVER-1-PRECHECK
  #   plan_execution_type: SWITCHOVER_PRECHECK
  #   timeouts_create: 60m
  #   are_prechecks_enabled: false
  - execution_display_name: SWITCHOVER-1
    plan_execution_type: SWITCHOVER
    timeouts_create: 60m
```

```bash
terraform apply
``` 

Once the switchover plan is completed, DR protection group roles will be swapped automatically, Region 2 will become primary and Region 1 will become standby

**Step 7: Create DR plans and execute DR plans in standby(region1) and run terraform apply** 

You can follow Step 5 and Step 6. Makee sure to change the plan name, type etc accordingly. 

With this we have completed Switchover from Region 1 to 2 and then Switchover from Region 2 to Region 1.


## Important: Managing Members in YAML Files

Pay attention to how `add_members` and `remove_members` work in the YAML configuration files:

**add_members:**
- Use this to add new members OR modify existing ones
- After running `terraform apply`, remove those members from the YAML for the next run
- They stay in the DR protection group, just remove them from the config file

**remove_members:**
- Use this to delete members from the DR protection group
- Add the member OCIDs you want to remove

**Example - Removing members:**

`region1.yaml`:
```yaml
remove_members:
- "ocid1.cluster.oc1.iad.xxx"
- "ocid1.autonomousdatabase.oc1.iad.xxx"
```

`region2.yaml`:
```yaml
remove_members:
- "ocid1.cluster.oc1.phx.yyy"
- "ocid1.autonomousdatabase.oc1.phx.yyy"
```

## Questions or issues?

Open an issue in this repo if you need help.