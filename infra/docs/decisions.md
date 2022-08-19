# Decisions
## Networking
* Connect the nodes internally with Tailscale
* Use MetalLB as ingress method into cluster
    * OCI always free load balancer capped at 10 Mbps
    * GCP and AWS don't have free load balancer options
    * Probably just use nginx ingress controller
* Use Flannel CNI for simplicity, and supported by MetalLB
* external-dns because it's simple and lightweight, not sure if i'll need to dns transfer to a provider it supports
* Certs with cert-manager

## Auth
* Keycloak because it seems popular and fun to try out