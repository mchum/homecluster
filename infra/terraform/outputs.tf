output "oracle_node_ip" {
    description = "IP of OCI node"
    value = oci_core_instance.node.public_ip
}
