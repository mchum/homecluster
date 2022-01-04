provider "oci" {
    tenancy_ocid        = var.tenancy_ocid
    user_ocid           = var.user_ocid
    private_key_path    = var.private_key_path
    fingerprint         = var.fingerprint
    region              = var.region
}

# Free Tier: Max 2 VCNs
resource "oci_core_vcn" "main" {
    display_name = "vcn_main"
    compartment_id = var.compartment_ocid
    cidr_blocks = ["10.0.0.0/16"]
}

resource "oci_core_subnet" "private" {
    cidr_block = "10.0.0.0/24"
    compartment_id = var.compartment_ocid
    vcn_id = oci_core_vcn.main.id
}

# Free Tier: 4 ARM-based A1 cores and 24 GB memory
resource "oci_core_instance" "homecluster_node" {
    # Required
    availability_domain = var.availability_domain
    compartment_id = var.compartment_ocid
    shape = "VM.Standard.A1.Flex"
    source_details {
        source_id = var.image_source_ocid
        source_type = "image"
    }

    # Optional
    display_name = "homecluster_node"
    shape_config {
        ocpus = 4
        memory_in_gbs = 24
    }
    create_vnic_details {
        assign_public_ip = false
        subnet_id = oci_core_subnet.private.id
    }
    preserve_boot_volume = false
}