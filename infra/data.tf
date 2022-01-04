data "template_cloudinit_config" "homecluster_node" {
  gzip          = true
  base64_encode = true
  part {
    filename     = "server.yaml"
    content_type = "text/cloud-config"
    content      = file("${path.module}/cloud-init/server.yaml")
  }
}

