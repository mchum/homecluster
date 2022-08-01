# Notes

## Manual steps
### Setup
**Local Node**

Label the local node for node selection
```
kubectl label node ${local_node_name} node.kubernetes.io/location=local
```

Create tailscale auth secret, auth key expires every 90 days
TODO: Set reminders to renew that ahead of time
```
kubectl create namespace tailscale
kubectl create secret generic tailscale-auth -n tailscale --from-literal="AUTH_KEY=${AUTH_KEY}"
```

**Edge Node**
Agent doesn't start with bootstrap, ssh and restart the service. Can probably handle this in Ansible or something down the line.
```
systemctl restart --now k3s-agent.service
```

Label the worker node as a worker
```
kubectl label node  ${node_name} node-role.kubernetes.io/worker=true
kubectl label node  ${node_name} node.kubernetes.io/location=edge
```

## Notes
Install latest k3s
```
curl -sfL https://get.k3s.io | INSTALL_K3S_CHANNEL=latest sh -
```

K3s agent not registering because of duplicate secrets
```
kubectl -n kube-system delete secrets ${node_name}.node-password.k3s
```