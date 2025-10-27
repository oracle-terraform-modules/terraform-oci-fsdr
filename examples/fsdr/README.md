# OCI Full Stack Disaster Recovery - Terraform Module

This Terraform module sets up the OCI Full Stack DR configuration between two OCI regions. It handles everything from creating protection groups to running DR plans.

## What it does

The module automates the entire Full Stack DR setup process:

- Creates DR protection groups (DRPG) in both regions
- Adds your resources as members to each DRPG
- Associate the DRPG with the primary and standby roles
- Creates switchover plan
- Executes the switchover plan

You can also modify, add, or remove members as needed. The terraform module intelligently validates members directly from the DR protection groups to manage new resource creation—such as moving compute resources—during DR plan execution. However, any failures encountered during plan execution must be handled outside of Terraform. There is no option to add user-defined plan groups as of today.

## Example Setup

This example demonstrates protecting resources across two regions using Full Stack DR. Region 1 serves as the primary region and Region 2 as the standby region.

**Regions:**
- **Region 1:** Ashburn (Primary)
- **Region 2:** Phoenix (Standby)

### Protected Resources

**Region 1 DR Protection Group:**
- Autonomous Database (Primary)
- OKE Cluster (Primary)
- Compute Instance (Movable)
- Volume Group

**Region 2 DR Protection Group:**
- Autonomous Database (Standby)
- OKE Cluster (Standby)


## How to use it

### Step 1: Configure Your Regions and Authentication Method

Open `providers.tf` and update it with your region identifiers and authentication method.

**Example configuration:**

- **Region 1:** Your primary region (e.g., Ashburn)
  - `auth = "SecurityToken"`
  - `config_file_profile = "IAD"`

- **Region 2:** Your standby region (e.g., Phoenix)
  - `auth = "SecurityToken"`
  - `config_file_profile = "PHX"`

### Step 2: Initialize Terraform
```bash
terraform init
```

### Step 3: Review the various resource sections in both region 1 and Region 2 YAML Files

Before updating, review the structure of both YAML files (`region1.yaml` and `region2.yaml`). Make sure to:

- Enter correct details in the proper format
- Use correct indentation
- Comment out sections as needed for each step

#### Section 1: DR Protection Group Configuration

Provide the DR protection group details, compartment OCID, and other settings to create and associate roles.

**region1.yaml**
```yaml
compartment_id: "ocid1.compartment.oc1..cccc" # Enter your DR protection group compartment ID
protection_group_display_name: "app-iad" # Enter your DR protection group name
log_location:
  bucket: "drpg-logs-iad" # Create a bucket and enter its name
  namespace: "xxxx" # Enter your bucket namespace
peer_region: "us-phoenix-1" # Enter the peer region
disassociate_trigger: null
```
**region2.yaml**
```yaml
compartment_id: "ocid1.compartment.oc1..cccc" # Enter your DR protection group compartment ID
protection_group_display_name: "app-phx" # Enter your DR protection group name
log_location:
  bucket: "drpg-logs-phx" # Create a bucket and enter its name
  namespace: "xxxx" # Enter your bucket namespace
disassociate_trigger: null
```

#### Section 2: Add Members

Add members based on your member type. **Remove the empty brackets `[]`** and list your members in both YAML files. You can also modify any properties for an existing member.
```yaml
add_members: []
```

#### Section 3: Remove Members

Provide the OCIDs of members to be removed based on member type. **Remove the empty brackets `[]`** and list the OCIDs in the respective YAML files.
```yaml
remove_members: []
```

#### Section 4: DR Plan and Execution

Update the DR plan type and execution details in both YAML files. 

**Note:** Full Stack DR always creates DR plans and executions in the standby DR protection group.
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
      - execution_display_name: SWITCHOVER-1
        plan_execution_type: SWITCHOVER
        timeouts_create: 120m
```

### Step 4: Create region1.yaml and region2.yaml

**Important:** Do not use the provided region1 and region2 YAML template files initially. Those templates are meant to be used as reference to see how the region1 and region2 yaml files will look like after completing switchover operations from region1 to region2 and back.

Instead, create new YAML files following the instructions below.

#### Create region1.yaml

Create a `region1.yaml` file with details from Section 1 and Section 2. For `add_members`, remove the empty brackets `[]` and add the members of the primary region. Update all values according to your configuration.
```yaml
#################
# Region1 Setup #
#################
compartment_id: "ocid1.compartment.oc1..xxxx" # Enter your DR protection group compartment ID
protection_group_display_name: "app-iad" # Enter your DR protection group name
log_location:
  bucket: "drpg-logs-iad" # Create a bucket and enter its name
  namespace: "xxxx" # Enter your bucket namespace
peer_region: "us-phoenix-1" # Enter the peer region
disassociate_trigger: null
add_members:
  - autonomous_database_standby_type_for_dr_drills: "SNAPSHOT_STANDBY"
    member_id: "ocid1.autonomousdatabase.oc1.iad.xxxx" # Enter your ATP database OCID
    member_type: "AUTONOMOUS_DATABASE"
  - member_id: "ocid1.cluster.oc1.iad.xxxx" # Enter your OKE OCID
    member_type: "OKE_CLUSTER"
    peer_cluster_id: "ocid1.cluster.oc1.phx.yyyy" # Enter your peer OKE OCID
    backup_location:
      bucket: "oke-backup-iad" # Create a bucket and enter its name
      namespace: "xxxx" # Enter your bucket namespace
    backup_config:
      backup_schedule: "FREQ=HOURLY;BYHOUR=0;BYMINUTE=0;INTERVAL=1"
      exclude_namespaces: []
      image_replication_vault_secret_id: null
      max_number_of_backups_retained: 3
      namespaces: ["ns1", "ns2"] # Enter your Kubernetes namespace list
      replicate_images: "ENABLE"
  - member_id: "ocid1.volumegroup.oc1.iad.xxxx" # Enter your volume group OCID
    member_type: "VOLUME_GROUP"
  - member_id: "ocid1.instance.oc1.iad.xxxx" # Enter your compute instance OCID
    member_type: "COMPUTE_INSTANCE_MOVABLE"
    vnic_mapping: []
    vnic_mappings:
      - destination_nsg_id_list: []
        destination_primary_private_ip_address: ""
        destination_primary_private_ip_hostname_label: ""
        destination_reserved_public_ip_id: ""
        destination_subnet_id: "ocid1.subnet.oc1.phx.yyyy" # Enter your destination subnet OCID
        source_vnic_id: "ocid1.vnic.oc1.iad.xxxx" # Enter your source VNIC OCID
```

#### Create region2.yaml

Create a `region2.yaml` file and remove the empty brackets `[]` from `add_members`. Add the members of the standby region. Update all values according to your configuration.
```yaml
#################
# Region2 Setup #
#################
compartment_id: "ocid1.compartment.oc1..xxxx" # Enter your DR compartment ID
protection_group_display_name: "app-phx"
log_location:
  bucket: "drpg-logs-phx" # Create a bucket and enter its name
  namespace: "xxxx" # Enter your bucket namespace
disassociate_trigger: null
add_members:
  - autonomous_database_standby_type_for_dr_drills: "REFRESHABLE_CLONE"
    member_id: "ocid1.autonomousdatabase.oc1.phx.yyyy" # Enter your ATP database OCID
    member_type: "AUTONOMOUS_DATABASE"
  - member_id: "ocid1.cluster.oc1.phx.yyyy" # Enter your OKE OCID
    member_type: "OKE_CLUSTER"
    peer_cluster_id: "ocid1.cluster.oc1.iad.xxxx" # Enter your peer OKE OCID
    backup_location:
      bucket: "oke-backup-phx" # Enter your bucket name
      namespace: "xxxx" # Enter your bucket namespace
    backup_config:
      backup_schedule: "FREQ=HOURLY;BYHOUR=0;BYMINUTE=0;INTERVAL=1"
      exclude_namespaces: []
      image_replication_vault_secret_id: null
      max_number_of_backups_retained: 3
      namespaces: ["ns1", "ns2"] # Enter your Kubernetes namespace list
      replicate_images: "ENABLE"
```

### Step 5: Apply the Configuration

Apply the configuration to create DR protection groups, associate roles, and add members.

#### Review the planned changes
```bash
terraform plan
```

#### Apply the configuration
```bash
terraform apply
```

#### Verify the setup

After applying the configuration, verify that:
- DR protection groups are created successfully
- Correct roles are associated
- Members are added to the protection groups

### Step 6: Create DR Plan in Standby Region (Region 2)

Full Stack DR allows you to create DR plans only in the protection group with the "Standby role". Therefore, you must first create the DR plan in Region 2.

#### Update region2.yaml

Add the DR plan configuration to `region2.yaml`. The `dr_plan_and_execution` section should appear after the `add_members` section.
```yaml
dr_plan_and_execution:
  - plan_display_name: SWITCHOVER-TO-PHOENIX
    type: SWITCHOVER
    refresh_trigger: null
    verify_trigger: null
```

**Note:** You can also create other supported plan types such as Failover and DR drills. This example uses a Switchover plan.

#### Apply the configuration
```bash
terraform apply
```

#### Verify the DR plan

After applying the configuration, verify that the DR Switchover plan has been created successfully in Region 2.

### Step 7: Execute DR Plans in Standby Region (Region 2)

It is highly recommended to first run switchover prechecks and verify successful execution before proceeding with the actual switchover.

#### Run Switchover Prechecks

Update `region2.yaml` to run the switchover prechecks by adding the `plan_execution` details:
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

Apply the configuration:
```bash
terraform apply
```

#### Execute the Switchover Plan

Once the prechecks are completed successfully, update `region2.yaml` to run the switchover plan.

**Note:** The `timeouts_create` is set to 120 minutes. You can increase this value if you need additional time based on your requirements.
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
      - execution_display_name: SWITCHOVER-1
        plan_execution_type: SWITCHOVER
        timeouts_create: 120m
```

Apply the configuration:
```bash
terraform apply
```

#### Validate the Execution

After the switchover plan completes successfully:
- Verify the plan execution
- DR protection group roles will be automatically swapped
- Region 2 will become the primary region
- Region 1 will become the standby region

### Step 8: Create and Execute DR Plans in Standby Region (Region 1)

After the switchover, Region 1 is now the standby region. Follow these steps to create and execute DR plans in Region 1.

#### Prepare the YAML files

**a. Update region1.yaml:**
- Add empty brackets `[]` to `add_members`
- Comment out the member properties 

**b. Update region2.yaml:**
- Add empty brackets `[]` to `add_members`
- Comment out the member properties

**c. Add DR plan configuration to region1.yaml:**

Since Region 1 is now the standby region, Full Stack DR will allow you to create and execute DR plans in Region 1. Follow the same steps as Step 6 and Step 7, but apply them to `region1.yaml`. Make sure to change the plan name, type, and other details accordingly.

#### Example configuration

Once completed and executed, `region1.yaml` should look like this:
```yaml
dr_plan_and_execution:
  - plan_display_name: SWITCHOVER-TO-ASHBURN
    type: SWITCHOVER
    refresh_trigger: null
    verify_trigger: null
    plan_execution:
      - execution_display_name: SWITCHOVER-1-PRECHECK
        plan_execution_type: SWITCHOVER_PRECHECK
        timeouts_create: 60m
        are_prechecks_enabled: false
      - execution_display_name: SWITCHOVER-1
        plan_execution_type: SWITCHOVER
        timeouts_create: 120m
```

#### Summary

You have now completed:
- Switchover from Region 1 to Region 2
- Switchover from Region 2 to Region 1
- Both regions now have switchover plans

You can also create failover plans and drill plans following the same approach.

---

## Important: Managing Members in YAML Files

Understanding how `add_members` and `remove_members` work is crucial for proper configuration management.


### add_members
- Use this to add new members OR modify existing ones
- After running `terraform apply`, remove those members from the YAML file for the next run
- Members remain in the DR protection group; you're just removing them from the configuration file

### remove_members
- Use this to delete members from the DR protection group
- Add the member OCIDs you want to remove

#### Example: Removing Members

**region1.yaml:**
```yaml
remove_members:
  - "ocid1.cluster.oc1.iad.xxx"
  - "ocid1.autonomousdatabase.oc1.iad.xxx"
```

**region2.yaml:**
```yaml
remove_members:
  - "ocid1.cluster.oc1.phx.yyy"
  - "ocid1.autonomousdatabase.oc1.phx.yyy"
```

### Plan execution failures

Any plan failures encountered during plan execution must be handled outside of Terraform. 
---

## Questions or Issues?

If you need help, please open an issue in this repository.
