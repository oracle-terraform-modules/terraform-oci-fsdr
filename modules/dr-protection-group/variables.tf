// Copyright (c) 2025, Oracle and/or its affiliates.
// Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl


variable "compartment_id" {
  type = string
}

variable "defined_tags" {
  type    = map(string)
  default = null
}
variable "disassociate_trigger" {
  type    = number
  default = null
}

variable "display_name" {
  type = string
}

variable "freeform_tags" {
  type    = map(string)
  default = null
}

variable "log_location" {
  type = object({
    bucket    = string
    namespace = string
  })
}

variable "association" {
  type = object({
    role        = string
    peer_id     = optional(string, null)
    peer_region = optional(string, null)
  })
  default = null
}

variable "members" {
  type = list(object({
    autonomous_database_standby_type_for_dr_drills = optional(string, null)
    member_id                                      = string
    member_type                                    = string
    bucket                                         = optional(string, null)
    connection_string_type                         = optional(string, null)
    destination_availability_domain                = optional(string, null)
    destination_backup_policy_id                   = optional(string, null)
    destination_capacity_reservation_id            = optional(string, null)
    destination_compartment_id                     = optional(string, null)
    destination_dedicated_vm_host_id               = optional(string, null)
    destination_load_balancer_id                   = optional(string, null)
    destination_network_load_balancer_id           = optional(string, null)
    destination_snapshot_policy_id                 = optional(string, null)
    gtid_reconciliation_timeout                    = optional(number, 0)
    is_continue_on_gtid_reconciliation_timeout     = optional(bool, false)
    is_movable                                     = optional(bool, false)
    is_retain_fault_domain                         = optional(bool, false)
    is_start_stop_enabled                          = optional(bool, false)
    jump_host_id                                   = optional(string, null)
    namespace                                      = optional(string, null)
    password_vault_secret_id                       = optional(string, null)
    peer_cluster_id                                = optional(string, null)
    peer_db_system_id                              = optional(string, null)
    backend_set_mappings = optional(list(object({
      destination_backend_set_name   = optional(string, null)
      is_backend_set_for_non_movable = optional(bool, false)
      source_backend_set_name        = optional(string, null)
    })), [])
    backup_config = optional(object({
      backup_schedule                   = optional(string, null)
      exclude_namespaces                = optional(list(string), [])
      image_replication_vault_secret_id = optional(string, null)
      max_number_of_backups_retained    = optional(number, null)
      namespaces                        = optional(list(string), [])
      replicate_images                  = optional(string, null)
    }), null)
    backup_location = optional(object({
      bucket    = optional(string, null)
      namespace = optional(string, null)
    }), null)
    block_volume_attach_and_mount_operations = optional(object({
      attachments = optional(list(object({
        block_volume_id                         = optional(string, null)
        volume_attachment_reference_instance_id = optional(string, null)
      })), [])
      mounts = optional(list(object({
        mount_point = optional(string, null)
      })), [])
    }), {})
    common_destination_key = optional(object({
      encryption_key_id = optional(string, null)
      vault_id          = optional(string, null)
    }), null)
    db_system_admin_user_details = optional(object({
      password_vault_secret_id = optional(string, null)
      username                 = optional(string, null)
    }), null)
    db_system_replication_user_details = optional(object({
      password_vault_secret_id = optional(string, null)
      username                 = optional(string, null)
    }), null)
    destination_encryption_key = optional(object({
      encryption_key_id = optional(string, null)
      vault_id          = optional(string, null)
    }), null)
    export_mappings = optional(list(object({
      destination_mount_target_id = optional(string, null)
      export_id                   = optional(string, null)
    })), [])
    file_system_operations = optional(list(object({
      export_path = optional(string, null)
      mount_details = optional(object({
        mount_target_id = optional(string, null)
      }), null)
      unmount_details = optional(object({
        mount_target_id = optional(string, null)
      }), null)
      mount_point     = optional(string, null)
      mount_target_id = optional(string, null)
    })), [])
    load_balancer_mappings = optional(list(object({
      destination_load_balancer_id = optional(string, null)
      source_load_balancer_id      = optional(string, null)
    })), [])
    managed_node_pool_configs = optional(list(object({
      id      = optional(string, null)
      maximum = optional(number, null)
      minimum = optional(number, null)
    })), [])
    network_load_balancer_mappings = optional(list(object({
      destination_network_load_balancer_id = optional(string, null)
      source_network_load_balancer_id      = optional(string, null)
    })), [])
    source_volume_to_destination_encryption_key_mappings = optional(list(object({
      source_volume_id = optional(string, null)
      destination_encryption_key = optional(object({
        encryption_key_id = optional(string, null)
        vault_id          = optional(string, null)
      }), null)
    })), [])
    vault_mappings = optional(list(object({
      destination_vault_id = optional(string, null)
      source_vault_id      = optional(string, null)
    })), [])
    virtual_node_pool_configs = optional(list(object({
      id      = optional(string, null)
      maximum = optional(number, null)
      minimum = optional(number, null)
    })), [])
    vnic_mapping = optional(list(object({
      destination_nsg_id_list = optional(list(string), [])
      destination_subnet_id   = optional(string, null)
      source_vnic_id          = optional(string, null)
    })), [])
    vnic_mappings = optional(list(object({
      destination_nsg_id_list                       = optional(list(string), [])
      destination_primary_private_ip_address        = optional(string, null)
      destination_primary_private_ip_hostname_label = optional(string, null)
      destination_reserved_public_ip_id             = optional(string, null)
      destination_subnet_id                         = optional(string, null)
      source_vnic_id                                = optional(string, null)
    })), [])
  }))
  default = []
}