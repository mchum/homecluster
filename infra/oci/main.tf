provider "oci" {
    tenancy_ocid        = var.tenancy_ocid
    user_ocid           = var.user_ocid
    private_key_path    = var.private_key_path
    fingerprint         = var.fingerprint
    region              = var.region
}

terraform {
    required_version = ">= 1.1.7"
}

# Networking
module "vcn" {
    source  = "oracle-terraform-modules/vcn/oci"
    version = "3.1.0"

    # Required
    compartment_id                  = var.compartment_ocid
    region                          = var.region
    vcn_name                        = "eggsalad"

    # Optional
    # By default, free tier service limit for NAT Gateway is 0
    lockdown_default_seclist        = false
    create_internet_gateway         = true
    create_nat_gateway              = false
    enable_ipv6                     = true
    vcn_cidrs                       = ["10.0.0.0/16"]
}

resource "oci_core_route_table" "eggsalad" {
    compartment_id = var.compartment_ocid
    vcn_id = module.vcn.vcn_id
    display_name = "Egg Salad"
    route_rules {
        network_entity_id = module.vcn.internet_gateway_id
        description = "Allow access from all IPs"
        destination = "0.0.0.0/0"
        destination_type = "CIDR_BLOCK"
    }
}

resource "oci_core_security_list" "eggsalad" {
    # Required
    compartment_id = var.compartment_ocid
    vcn_id = module.vcn.vcn_id
    display_name = "Egg Salad Security List"
    egress_security_rules {
        protocol            = "all"
        destination         = "0.0.0.0/0"
        destination_type    = "CIDR_BLOCK"
    }
    ingress_security_rules {
        protocol    = "6"
        source      = "0.0.0.0/0"
        source_type = "CIDR_BLOCK"
        description = "TCP traffic to port 22"
        tcp_options {
            source_port_range {
                min = 22
                max = 22
            }
        }
    }
    ingress_security_rules {
        protocol    = "6"
        source      = "0.0.0.0/0"
        source_type = "CIDR_BLOCK"
        description = "Kubernetes API Server"
        tcp_options {
            source_port_range {
                min = 6443
                max = 6443
            }
        }
    }
    ingress_security_rules {
        protocol    = "6"
        source      = "0.0.0.0/0"
        source_type = "CIDR_BLOCK"
        description = "Kubelet metrics"
        tcp_options {
            source_port_range {
                min = 10250
                max = 10250
            }
        }
    }
}

resource "oci_core_subnet" "public" {
    cidr_block                  = "10.0.0.0/24"
    compartment_id              = var.compartment_ocid
    vcn_id                      = module.vcn.vcn_id
    display_name                = "public"
    prohibit_internet_ingress   = false
    prohibit_public_ip_on_vnic  = false
    route_table_id              = oci_core_route_table.eggsalad.id
}

# Compute
# Free Tier: 
# * 4 ARM-based A1 cores and 24 GB memory
# * 200 GB block storage, minimum 50 GB used here
resource "oci_core_instance" "worker_node" {
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
    display_name = "worker_node"
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
        user_data = base64encode(
            templatefile("${path.module}/../bootstrap/ubuntu_worker.sh",
            {
                K3S_URL     = var.k3s_url,
                K3S_TOKEN   = var.k3s_token,
            })
        )
    }
}

output "worker_node_ip" {
    description = "IP of worker node"
    value = oci_core_instance.worker_node.public_ip
}