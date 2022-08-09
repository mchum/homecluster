# Notes

## Manual steps
### Set up oci nodes
1. Create the node and all resources required to facilitate it
    ```
    user@homecluster/infra$ cd terraform/oci
    user@homecluster/infra/terraform/oci$ terraform apply -auto-approve
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