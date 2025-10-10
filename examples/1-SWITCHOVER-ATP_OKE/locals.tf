// Copyright (c) 2025, Oracle and/or its affiliates.
// Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl


locals {
  region_of_execution = yamldecode(file("${path.module}/execution.yaml"))["Region_of_execution"]
  primary_members     = [for member in yamldecode(file("${path.module}/region1.yaml"))["region1_dr_pg"]["members"] : member]
  altered_primary_members = [
    for entry in local.primary_members : {
      autonomous_database_standby_type_for_dr_drills = try(entry.autonomous_database_standby_type_for_dr_drills, null)
      member_id                                      = entry.member_id
      member_type                                    = entry.member_type
      connection_string_type                         = try(entry.connection_string_type, null)
      gtid_reconciliation_timeout                    = try(entry.gtid_reconciliation_timeout, 0)
      is_continue_on_gtid_reconciliation_timeout     = try(entry.is_continue_on_gtid_reconciliation_timeout, false)
      jump_host_id                                   = try(entry.jump_host_id, null)
      password_vault_secret_id                       = try(entry.password_vault_secret_id, null)
      peer_cluster_id                                = try(entry.peer_cluster_id, null)
      peer_db_system_id                              = try(entry.peer_db_system_id, null)
      backup_config                                  = local.region_of_execution != "REGION1" ? try(entry.backup_config, null) : null
      backup_location                                = try(entry.backup_location, null)
      db_system_admin_user_details                   = try(entry.db_system_admin_user_details, null)
      db_system_replication_user_details             = try(entry.db_system_replication_user_details, null)
      destination_encryption_key                     = try(entry.destination_encryption_key, null)
      load_balancer_mappings                         = try(entry.load_balancer_mappings, [])
      managed_node_pool_configs                      = try(entry.managed_node_pool_configs, [])
      network_load_balancer_mappings                 = try(entry.network_load_balancer_mappings, [])
      vault_mappings                                 = try(entry.vault_mappings, [])
      virtual_node_pool_configs                      = try(entry.virtual_node_pool_configs, [])
    }
  ]
  standby_members = [for member in yamldecode(file("${path.module}/region2.yaml"))["region2_dr_pg"]["members"] : member]
  altered_standby_members = [
    for entry in local.standby_members : {
      autonomous_database_standby_type_for_dr_drills = try(entry.autonomous_database_standby_type_for_dr_drills, null)
      member_id                                      = entry.member_id
      member_type                                    = entry.member_type
      connection_string_type                         = try(entry.connection_string_type, null)
      gtid_reconciliation_timeout                    = try(entry.gtid_reconciliation_timeout, 0)
      is_continue_on_gtid_reconciliation_timeout     = try(entry.is_continue_on_gtid_reconciliation_timeout, false)
      jump_host_id                                   = try(entry.jump_host_id, null)
      password_vault_secret_id                       = try(entry.password_vault_secret_id, null)
      peer_cluster_id                                = try(entry.peer_cluster_id, null)
      peer_db_system_id                              = try(entry.peer_db_system_id, null)
      backup_config                                  = local.region_of_execution != "REGION2" ? try(entry.backup_config, null) : null
      backup_location                                = try(entry.backup_location, null)
      db_system_admin_user_details                   = try(entry.db_system_admin_user_details, null)
      db_system_replication_user_details             = try(entry.db_system_replication_user_details, null)
      destination_encryption_key                     = try(entry.destination_encryption_key, null)
      load_balancer_mappings                         = try(entry.load_balancer_mappings, [])
      managed_node_pool_configs                      = try(entry.managed_node_pool_configs, [])
      network_load_balancer_mappings                 = try(entry.network_load_balancer_mappings, [])
      vault_mappings                                 = try(entry.vault_mappings, [])
      virtual_node_pool_configs                      = try(entry.virtual_node_pool_configs, [])
    }
  ]
}
