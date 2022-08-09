# Notes

## Manual steps
### Set up oci nodes
1. Set up OCI private key in `${HOME}/.secrets/oci/private.pem`
1. Create OCI provider secrets in `${HOME}/.secrets/oci/provider.tfvars`
    ```
    # Example
    tenancy_ocid="ocid1.tenancy.oc1..aaaaaaa"
    user_ocid="ocid1.user.oc1..aaaaa"
    private_key_path="/home/mchum/.secrets/oci/private.pem"
    fingerprint="aa:bb:cc:dd:ee:ff:gg:hh:ii:jj:kk:ll:mm:nn:oo:pp"
    compartment_ocid="ocid1.compartment.oc1..aaaaaaa"
    region="ca-toronto-1"
    ```
1. Create the node and all resources required to facilitate it
    ```
    user@homecluster/infra$ cd terraform/oci
    user@homecluster/infra/terraform/oci$ terraform apply -auto-approve \
        -var-file terraform.tfvars \
        -var-file ${HOME}/.secrets/oci/provider.tfvars
    ...
    worker_node_ip = "132.145.98.241"
    ```
2. Add this node IP to `infra/ansible/hosts.ini` under `[workers]`

### Configure the nodes
1. Set the ansible vault password in `${HOME}/.secrets/ansible_vault_password_file`
2. Apply the ansible playbook
    ```
    user@homecluster/infra$ cd ansible
    user@homecluster/infra/ansible$ ansible-playbook site.yaml \
        -i ./hosts.ini \
        --vault-password-file ${HOME}/.secrets/ansible_vault_password_file
    ```