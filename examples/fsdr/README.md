# FSDR

The module is for creating full stack disaster recovery protection group, plan and execution.

Step1: Initialize the terraform

```bash
terraform init
```

Step2: Update the region1.yaml(primary) and region2.yaml(standby) with necesary config.

region1.yaml remove the empty set of add_member and add the members to the primary.

```yaml
add_members:
- autonomous_database_standby_type_for_dr_drills: "SNAPSHOT_STANDBY"
  member_id: "ocid1.autonomousdatabase.oc1.phx.xxx" # update the atp db ocid
  member_type: "AUTONOMOUS_DATABASE"
- member_id: "ocid1.cluster.oc1.phx.xxx" # update the oke ocid
  member_type: "OKE_CLUSTER"
  peer_cluster_id: "ocid1.cluster.oc1.eu-frankfurt-1.yyy" # update the peer oke ocid
  backup_location:
    bucket: "bucket-dr-backup-drtest" # update the bucket name
    namespace: "XXX" # update the bucket namespace
  backup_config:
    backup_schedule: "FREQ=HOURLY;BYHOUR=0;BYMINUTE=0;INTERVAL=1"
    exclude_namespaces: []
    image_replication_vault_secret_id: null
    max_number_of_backups_retained: 3
    namespaces: ["ns1", "ns2"] # update the list of kubernetes namespace
    replicate_images: "ENABLE"
- member_id: ocid1.volumegroup.oc1.phx.xxx
  member_type: VOLUME_GROUP
```

region2.yaml remove the empty set of add_member and add the members to the standby. Also in standby, don't need to add backup config for OKE_CLUSTER member type.

```yaml
add_members:
- member_id: "ocid1.cluster.oc1.eu-frankfurt-1.yyy" # update the oke ocid
  member_type: "OKE_CLUSTER"
  peer_cluster_id: "ocid1.cluster.oc1.phx.aaaaaaaap67t4qjlkavn2ohs3pcf44nrfxcyzlkmaibd25mnrcd7eukmkcnq" # update the peer oke ocid
  backup_location:
    bucket: "bucket-oke-backup-frankfurt" # update the bucket name
    namespace: "xxx" # update the bucket namespace
- autonomous_database_standby_type_for_dr_drills: "REFRESHABLE_CLONE"
  member_id: "ocid1.autonomousdatabase.oc1.eu-frankfurt-1.yyy" # update the atp db ocid
  member_type: "AUTONOMOUS_DATABASE"
```

###NOTE: 

add_member: option is used for adding newmbers and modufying existing members. Also once the member is added/modified by running terraform apply, for the next run members has to be removed from the yaml.

remove_members: option is used for removing the existing meber from the protection group.adding the member_id list will remove it from the protection group.

region1.yaml
```yaml
remove_members:
- "ocid1.cluster.oc1.phx.xxx"
- "ocid1.autonomousdatabase.oc1.phx.xxx"
```

region2.yaml
```yaml
remove_members:
- "ocid1.cluster.oc1.eu-frankfurt-1.yyy"
- "ocid1.autonomousdatabase.oc1.eu-frankfurt-1.yyy"
```
Step3: Apply the config for creating protection group and adding member to it.

```bash
terraform apply
```

Step4: To create dr plan in standby(region2) add the plans as list. And run terraform apply.

region2.yaml
```yaml
dr_plan_and_execution:
- plan_display_name: SWITCHOVER-TO-FRANKFURT
  type: SWITCHOVER
  refresh_trigger: null
  verify_trigger: null
  plan_execution: []
```

Step5: To create the execution of plan, update the list and run terraform apply.

region2.yaml
```yaml
dr_plan_and_execution:
- plan_display_name: SWITCHOVER-TO-FRANKFURT
  type: SWITCHOVER
  refresh_trigger: null
  verify_trigger: null
  plan_execution:
  - execution_display_name: SWITCHOVER-1
    plan_execution_type: SWITCHOVER
    timeouts_create: 60m
```

With this the SWITCHOVER is completed, Now the region2(PRIMARY) and region1(STANDBY)

Step6: To create a plan and execution from region1(STANDBY), follow step 4 and 5 in region1.yaml.
