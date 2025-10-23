// Copyright (c) 2025, Oracle and/or its affiliates.
// Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl



data "oci_disaster_recovery_dr_protection_groups" "region1_dr_protection_groups" {
  provider       = oci.region1
  compartment_id = var.region1_config["compartment_id"]
  display_name   = var.region1_config["protection_group_display_name"]
}

locals {
  region1_get_protection_group           = try(data.oci_disaster_recovery_dr_protection_groups.region1_dr_protection_groups.dr_protection_group_collection[0].items[0].id, null)
  region1_get_members                    = local.region1_get_protection_group != null ? data.oci_disaster_recovery_dr_protection_group.region1_dr_protection_group[0].members : []
  region1_member_id                      = [for entry in local.region1_get_members : entry.member_id]
  region1_modification_members           = { for entry in var.region1_config["add_members"] : entry.member_id => entry }
  region1_member_id_modification_members = [for entry in local.region1_modification_members : entry.member_id]
  region1_member_index_modification      = toset(setintersection(local.region1_member_id, local.region1_member_id_modification_members))
  region1_members_after_structure = [
    for entry in local.region1_get_members : {
      autonomous_database_standby_type_for_dr_drills = try(entry.autonomous_database_standby_type_for_dr_drills, "")
      member_id                                      = entry.member_id
      member_type                                    = entry.member_type
      bucket                                         = try(entry.bucket, "")
      connection_string_type                         = try(entry.connection_string_type, "")
      destination_availability_domain                = try(entry.destination_availability_domain, "")
      destination_backup_policy_id                   = try(entry.destination_backup_policy_id, "")
      destination_capacity_reservation_id            = try(entry.destination_capacity_reservation_id, "")
      destination_compartment_id                     = try(entry.destination_compartment_id, "")
      destination_dedicated_vm_host_id               = try(entry.destination_dedicated_vm_host_id, "")
      destination_load_balancer_id                   = try(entry.destination_load_balancer_id, "")
      destination_network_load_balancer_id           = try(entry.destination_network_load_balancer_id, "")
      destination_snapshot_policy_id                 = try(entry.destination_snapshot_policy_id, "")
      gtid_reconciliation_timeout                    = try(entry.gtid_reconciliation_timeout, 0)
      is_continue_on_gtid_reconciliation_timeout     = try(entry.is_continue_on_gtid_reconciliation_timeout, false)
      is_movable                                     = try(entry.is_movable, false)
      is_retain_fault_domain                         = try(entry.is_retain_fault_domain, false)
      is_start_stop_enabled                          = try(entry.is_start_stop_enabled, false)
      jump_host_id                                   = try(entry.jump_host_id, "")
      namespace                                      = try(entry.namespace, "")
      password_vault_secret_id                       = try(entry.password_vault_secret_id, "")
      peer_cluster_id                                = try(entry.peer_cluster_id, "")
      peer_db_system_id                              = try(entry.peer_db_system_id, "")
      backend_set_mappings                           = try(entry.backend_set_mappings, [])
      backup_config                                  = try(length(entry.backup_config), 0) == 0 ? null : try(entry.backup_config[0], entry.backup_config)
      backup_location                                = try(length(entry.backup_location), 0) == 0 ? null : try({ bucket = entry.backup_location[0]["bucket"], namespace = entry.backup_location[0]["namespace"] }, entry.backup_location)
      block_volume_attach_and_mount_operations       = try(length(entry.block_volume_attach_and_mount_operations), 0) == 0 ? null : try(entry.block_volume_attach_and_mount_operations[0], entry.block_volume_attach_and_mount_operations)
      common_destination_key                         = try(length(entry.common_destination_key), 0) == 0 ? null : try(entry.common_destination_key[0], entry.common_destination_key)
      db_system_admin_user_details                   = try(length(entry.db_system_admin_user_details), 0) == 0 ? null : try(entry.db_system_admin_user_details[0], entry.db_system_admin_user_details)
      db_system_replication_user_details             = try(length(entry.db_system_replication_user_details), 0) == 0 ? null : try(entry.db_system_replication_user_details[0], entry.db_system_replication_user_details)
      destination_encryption_key                     = try(length(entry.destination_encryption_key), 0) == 0 ? null : try(entry.destination_encryption_key[0], entry.destination_encryption_key)
      export_mappings                                = try(entry.export_mappings, [])
      file_system_operations = [for entry in try(entry.file_system_operations, []) :
        {
          export_path     = try(entry.export_path, null)
          mount_details   = try(length(entry.mount_details), 0) == 0 ? null : try(entry.mount_details[0], entry.mount_details)
          unmount_details = try(length(entry.unmount_details), 0) == 0 ? null : try(entry.unmount_details[0], entry.unmount_details)
          mount_point     = try(entry.mount_point, null)
          mount_target_id = try(entry.mount_target_id, null)
      }]
      load_balancer_mappings         = try(entry.load_balancer_mappings, [])
      managed_node_pool_configs      = try(entry.managed_node_pool_configs, [])
      network_load_balancer_mappings = try(entry.network_load_balancer_mappings, [])
      source_volume_to_destination_encryption_key_mappings = [for entry in try(entry.source_volume_to_destination_encryption_key_mappings, []) :
        {
          source_volume_id           = try(entry.source_volume_id, null)
          destination_encryption_key = try(length(entry.destination_encryption_key), 0) == 0 ? null : try(entry.destination_encryption_key[0], entry.destination_encryption_key)
      }]
      vault_mappings            = try(entry.vault_mappings, [])
      virtual_node_pool_configs = try(entry.virtual_node_pool_configs, [])
      vnic_mapping              = try(entry.vnic_mapping, [])
      vnic_mappings             = try(entry.vnic_mappings, [])
  } if !contains(var.region1_config["remove_members"], entry.member_id)]

  region1_modified_members = [for entry in local.region1_members_after_structure : try(local.region1_modification_members[entry.member_id], entry)]
  region1_append_members   = [for key, value in local.region1_modification_members : value if !contains(local.region1_member_index_modification, key)]
  region1_altered_members  = concat(local.region1_modified_members, local.region1_append_members)

}


data "oci_disaster_recovery_dr_protection_group" "region1_dr_protection_group" {
  count                  = local.region1_get_protection_group == null ? 0 : 1
  provider               = oci.region1
  dr_protection_group_id = data.oci_disaster_recovery_dr_protection_groups.region1_dr_protection_groups.dr_protection_group_collection[0].items[0].id
}
