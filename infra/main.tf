provider "oci" {
    tenancy_ocid        = var.tenancy_ocid
    user_ocid           = var.user_ocid
    private_key_path    = var.private_key_path
    fingerprint         = var.fingerprint
    region              = var.region
}

# Networking
module "vcn" {
    source  = "oracle-terraform-modules/vcn/oci"
    version = "3.1.0"

    # Required
    compartment_id                  = var.compartment_ocid
    region                          = var.region
    vcn_name                        = "main"
    vcn_dns_label                   = "idkwhatthisis"

    # Optional
    lockdown_default_seclist        = false
    create_internet_gateway         = true
    create_nat_gateway              = true
    enable_ipv6                     = true
    vcn_cidrs                       = ["10.0.0.0/16"]
}

resource "oci_core_subnet" "public" {
    cidr_block = "10.0.0.0/24"
    compartment_id = var.compartment_ocid
    vcn_id = module.vcn.vcn_id
}

# Compute
# Free Tier: 
# * 4 ARM-based A1 cores and 24 GB memory
# * 200 GB block storage, minimum 50 GB used here
resource "oci_core_instance" "homecluster_node" {
    # Required
    availability_domain = var.availability_domain
    compartment_id = var.compartment_ocid
    shape = "VM.Standard.A1.Flex"
    source_details {
        source_id = var.image_source_ocid
        source_type = "image"
        boot_volume_size_in_gbs = 50
    }

    # Optional
    display_name = "homecluster_node"
    shape_config {
        ocpus = 4
        memory_in_gbs = 24
    }
    create_vnic_details {
        assign_public_ip = true
        subnet_id = oci_core_subnet.public.id
    }
    preserve_boot_volume = false
    metadata = {
        ssh_authorized_keys = file(var.ssh_public_keypath)
        user_data           = data.template_cloudinit_config.homecluster_node.rendered
    }
}

output "homecluster_node_public_ip" {
    description = "Public IP of homecluster_node"
    value = oci_core_instance.homecluster_node.public_ip
}