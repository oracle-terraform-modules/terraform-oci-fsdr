# Terraform module for DR Protection Group

This terraform module is for creating dr protection group resource.

## Sample

```hcl
module "dr_protection_group" {
  source         = "oracle-terraform-modules/fsdr/oci//modules/dr-protection-group"
  compartment_id = "ocid1.compartment.oc1..xxx" 
  display_name   = "dr-pg-test-phx"
  log_location   = {
    bucket = "bucket-dr-log-drtest" 
    namespace = "XXX" 
  }
  association = {
    role = "PRIMARY"
    peer_id = "dr-pg-test-fra"
    peer_region = "eu-frankfurt-1" 
  }
  members = [ {
    autonomous_database_standby_type_for_dr_drills = "SNAPSHOT_STANDBY"
      member_id = "<atpdb-ocid>"
      member_type = "AUTONOMOUS_DATABASE" },
    {
      member_id = "<oke-ocid>"
      member_type = "OKE_CLUSTER"
      peer_cluster_id = "<peer-oke-ocid>"
      backup_config = {
        backup_schedule = "FREQ=HOURLY;BYHOUR=0;BYMINUTE=0;INTERVAL=1"
        exclude_namespaces = []
        image_replication_vault_secret_id = null
        max_number_of_backups_retained = 3
        namespaces = []
        replicate_images = "ENABLE"
      }
      backup_location = {
        bucket = "bucket-dr-backup-drtest"
        namespace = "iotdev"
      } 
    }, {
      member_id = "<bucket-ocid>"
      member_type = "OBJECT_STORAGE_BUCKET"
      namespace = "iotdev"
      bucket = "bucket-phx" 
    }]
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
| [oci_disaster_recovery_dr_protection_group.dr_protection_group](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/disaster_recovery_dr_protection_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_association"></a> [association](#input\_association) | n/a | <pre>object({<br/>    role = string<br/>    peer_id     = optional(string, null)<br/>    peer_region = optional(string, null)   <br/>  })</pre> | `null` | no |
| <a name="input_compartment_id"></a> [compartment\_id](#input\_compartment\_id) | n/a | `string` | n/a | yes |
| <a name="input_defined_tags"></a> [defined\_tags](#input\_defined\_tags) | n/a | `map(string)` | `null` | no |
| <a name="input_disassociate_trigger"></a> [disassociate\_trigger](#input\_disassociate\_trigger) | n/a | `number` | `null` | no |
| <a name="input_display_name"></a> [display\_name](#input\_display\_name) | n/a | `string` | n/a | yes |
| <a name="input_freeform_tags"></a> [freeform\_tags](#input\_freeform\_tags) | n/a | `map(string)` | `null` | no |
| <a name="input_log_location"></a> [log\_location](#input\_log\_location) | n/a | <pre>object({<br/>    bucket    = string<br/>    namespace = string<br/>  })</pre> | n/a | yes |
| <a name="input_members"></a> [members](#input\_members) | n/a | <pre>list(object({<br/>    autonomous_database_standby_type_for_dr_drills = optional(string, null)<br/>    member_id                                      = string<br/>    member_type                                    = string<br/>    bucket                                         = optional(string, null)<br/>    connection_string_type                         = optional(string, null)<br/>    destination_availability_domain                = optional(string, null)<br/>    destination_backup_policy_id                   = optional(string, null)<br/>    destination_capacity_reservation_id            = optional(string, null)<br/>    destination_compartment_id                     = optional(string, null)<br/>    destination_dedicated_vm_host_id               = optional(string, null)<br/>    destination_load_balancer_id                   = optional(string, null)<br/>    destination_network_load_balancer_id           = optional(string, null)<br/>    destination_snapshot_policy_id                 = optional(string, null)<br/>    gtid_reconciliation_timeout                    = optional(number, 0)<br/>    is_continue_on_gtid_reconciliation_timeout     = optional(bool, false)<br/>    is_movable                                     = optional(bool, false)<br/>    is_retain_fault_domain                         = optional(bool, false)<br/>    is_start_stop_enabled                          = optional(bool, false)<br/>    jump_host_id                                   = optional(string, null)<br/>    namespace                                      = optional(string, null)<br/>    password_vault_secret_id                       = optional(string, null)<br/>    peer_cluster_id                                = optional(string, null)<br/>    peer_db_system_id                              = optional(string, null)<br/>    backend_set_mappings = optional(list(object({<br/>      destination_backend_set_name   = optional(string, null)<br/>      is_backend_set_for_non_movable = optional(bool, false)<br/>      source_backend_set_name        = optional(string, null)<br/>    })), [])<br/>    backup_config = optional(object({<br/>      backup_schedule                   = optional(string, null)<br/>      exclude_namespaces                = optional(list(string), [])<br/>      image_replication_vault_secret_id = optional(string, null)<br/>      max_number_of_backups_retained    = optional(number, null)<br/>      namespaces                        = optional(list(string), [])<br/>      replicate_images                  = optional(string, null)<br/>    }), null)<br/>    backup_location = optional(object({<br/>      bucket    = optional(string, null)<br/>      namespace = optional(string, null)<br/>    }), null)<br/>    block_volume_attach_and_mount_operations = optional(object({<br/>      attachments = optional(list(object({<br/>        block_volume_id                         = optional(string, null)<br/>        volume_attachment_reference_instance_id = optional(string, null)<br/>      })), [])<br/>      mounts = optional(list(object({<br/>        mount_point = optional(string, null)<br/>      })), [])<br/>    }), {})<br/>    common_destination_key = optional(object({<br/>      encryption_key_id = optional(string, null)<br/>      vault_id          = optional(string, null)<br/>    }), null)<br/>    db_system_admin_user_details = optional(object({<br/>      password_vault_secret_id = optional(string, null)<br/>      username                 = optional(string, null)<br/>    }), null)<br/>    db_system_replication_user_details = optional(object({<br/>      password_vault_secret_id = optional(string, null)<br/>      username                 = optional(string, null)<br/>    }), null)<br/>    destination_encryption_key = optional(object({<br/>      encryption_key_id = optional(string, null)<br/>      vault_id          = optional(string, null)<br/>    }), null)<br/>    export_mappings = optional(list(object({<br/>      destination_mount_target_id = optional(string, null)<br/>      export_id                   = optional(string, null)<br/>    })), [])<br/>    file_system_operations = optional(list(object({<br/>      export_path = optional(string, null)<br/>      mount_details = optional(object({<br/>        mount_target_id = optional(string, null)<br/>      }), null)<br/>      unmount_details = optional(object({<br/>        unmount_target_id = optional(string, null)<br/>      }), null)<br/>      mount_point     = optional(string, null)<br/>      mount_target_id = optional(string, null)<br/>    })), [])<br/>    load_balancer_mappings = optional(list(object({<br/>      destination_load_balancer_id = optional(string, null)<br/>      source_load_balancer_id      = optional(string, null)<br/>    })), [])<br/>    managed_node_pool_configs = optional(list(object({<br/>      id      = optional(string, null)<br/>      maximum = optional(number, null)<br/>      minimum = optional(number, null)<br/>    })), [])<br/>    network_load_balancer_mappings = optional(list(object({<br/>      destination_network_load_balancer_id = optional(string, null)<br/>      source_network_load_balancer_id      = optional(string, null)<br/>    })), [])<br/>    source_volume_to_destination_encryption_key_mappings = optional(list(object({<br/>      source_volume_id = optional(string, null)<br/>      destination_encryption_key = optional(object({<br/>        encryption_key_id = optional(string, null)<br/>        vault_id          = optional(string, null)<br/>      }), null)<br/>    })), [])<br/>    vault_mappings = optional(list(object({<br/>      destination_vault_id = optional(string, null)<br/>      source_vault_id      = optional(string, null)<br/>    })), [])<br/>    virtual_node_pool_configs = optional(list(object({<br/>      id      = optional(string, null)<br/>      maximum = optional(number, null)<br/>      minimum = optional(number, null)<br/>    })), [])<br/>    vnic_mapping = optional(list(object({<br/>      destination_nsg_id_list = optional(list(string), [])<br/>      destination_subnet_id   = optional(string, null)<br/>      source_vnic_id          = optional(string, null)<br/>    })), [])<br/>    vnic_mappings = optional(list(object({<br/>      destination_nsg_id_list                       = optional(list(string), [])<br/>      destination_primary_private_ip_address        = optional(string, null)<br/>      destination_primary_private_ip_hostname_label = optional(string, null)<br/>      destination_reserved_public_ip_id             = optional(string, null)<br/>      destination_subnet_id                         = optional(string, null)<br/>      source_vnic_id                                = optional(string, null)<br/>    })), [])<br/>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dr_protection_group"></a> [dr\_protection\_group](#output\_dr\_protection\_group) | n/a |
