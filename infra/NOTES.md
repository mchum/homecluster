# Notes

## Issues
Agent doesn't start with bootstrap, ssh and restart the service
```
systemctl restart --now k3s-agent.service
```

Add role to node
```
kubectl label node  ${node_name} node-role.kubernetes.io/worker=true
```

Can't use k3s `--node-labels` because of the following error
```
--node-labels in the 'kubernetes.io' namespace must begin with an allowed prefix (kubelet.kubernetes.io, node.kubernetes.io) or be in the specifically allowed set (beta.kubernetes.io/arch, beta.kubernetes.io/instance-type, beta.kubernetes.io/os, failure-domain.beta.kubernetes.io/region, failure-domain.beta.kubernetes.io/zone, kubernetes.io/arch, kubernetes.io/hostname, kubernetes.io/os, node.kubernetes.io/instance-type, topology.kubernetes.io/region, topology.kubernetes.io/zone)
```

> ... proxy error from 127.0.0.1:6443 while dialing 10.0.0.226:10250, code 503: 503 Service Unavailable
Means master node can't communicate with worker node

## Notes
Install latest k3s
```
curl -sfL https://get.k3s.io | INSTALL_K3S_CHANNEL=latest sh -
```

K3s agent not registering because of duplicate secrets
```
kubectl -n kube-system delete secrets ${node_name}.node-password.k3s
```