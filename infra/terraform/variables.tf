variable "compartment_ocid" {
  type = string
  description = "Comparment to deploy to"
}

variable "ssh_public_keypath" {
  type = string
  description = "Path to RSA public key, OCI has issue with ed25519"
}

variable "bootstrap_script_filepath" {
  type = string
  description = "Path to bootstrap script"
  default = "bootstrap/startup.sh"
}