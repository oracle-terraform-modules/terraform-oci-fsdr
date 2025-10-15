// Copyright (c) 2025, Oracle and/or its affiliates.
// Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl


provider "oci" {
  alias               = "region1"
  region              = "us-phoenix-1"
  auth                = "SecurityToken"
  config_file_profile = "PHX"
}

provider "oci" {
  alias               = "region2"
  region              = "eu-frankfurt-1"
  auth                = "SecurityToken"
  config_file_profile = "FRA"
}

terraform {
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = ">= 5.0.0"
    }
  }
  required_version = ">= 1.3.0"
}