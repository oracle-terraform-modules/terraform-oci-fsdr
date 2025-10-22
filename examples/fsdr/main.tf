// Copyright (c) 2025, Oracle and/or its affiliates.
// Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl


module "fsdr" {
  source = "../../"
  providers = {
    oci.region1 = oci.region1
    oci.region2 = oci.region2
  }
  region1_config = yamldecode(file("${path.module}/region1.yaml"))
  region2_config = yamldecode(file("${path.module}/region2.yaml"))
}

output "region1_members" {
  value = yamlencode(module.fsdr.region1_members)
}

output "region2_members" {
  value = yamlencode(module.fsdr.region2_members)
}

output "region1_plan_ids" {
  value = module.fsdr.region1_plan_ids
}

output "region2_plan_ids" {
  value = module.fsdr.region2_plan_ids
}
