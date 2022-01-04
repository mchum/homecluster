variable "tenancy_ocid" {
  type = string
}

variable "user_ocid" {
  type = string
}

variable "private_key_path" {
  type = string
}

variable "fingerprint" {
  type = string
}

variable "region" {
  type = string
  default = "ca-toronto-1"
}

variable "availability_domain" {
  type = string
  default = "NAhl:CA-TORONTO-1-AD-1"
}

variable "compartment_ocid" {
  type = string
}

variable "image_source_ocid" {
  type = string 
}

variable "ssh_public_keypath" {
  type = string
}