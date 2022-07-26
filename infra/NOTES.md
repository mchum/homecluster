# Notes

## Adding role to nodes
```
kubectl label node  ${node_name} kubernetes.io/role=agent
```

## Updating k3s version
```
curl -sfL https://get.k3s.io | INSTALL_K3S_CHANNEL=latest sh -
```

## Secrets don't match
```
kubectl -n kube-system delete secrets ${node_name}.node-password.k3s
```