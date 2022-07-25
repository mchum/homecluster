# Notes

## Adding role to nodes
```
kubectl node  ${node_name} kubernetes.io/role=agent
```

## Updating k3s version
```
curl -sfL https://get.k3s.io | INSTALL_K3S_CHANNEL=latest sh -
```