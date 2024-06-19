# Provider details in ~/.oci/config
# Ensure you remove any comments (like "# TODO"), or it will cause a "bad configuration" error
provider "oci" {
    config_file_profile = "DEFAULT"
}

terraform {
  required_providers {
    oci = {
        source = "oracle/oci"
    }
  }
  
}
