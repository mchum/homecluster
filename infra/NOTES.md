# Notes

## Issues
Agent doesn't start with bootstrap, ssh and restart the service
```
systemctl restart --now k3s-agent.service
```

Add role to node
```
kubectl label node  ${node_name} kubernetes.io/role=agent
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