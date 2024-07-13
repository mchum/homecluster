# Infra
Setting up the Kubernetes cluster using as many free tier resources from cloud providers as I can because I am cheap and don't like paying for stuff.

## Table of Contents
* `terraform/` - Provisions nodes in cloud infrastructure
* `ansible/` - Configures nodes into a K3s cluster, and bootstraps the platform using Flux CLI
* `platform-apps/` - Flux-managed Kubernetes/Helm configurations
* `docs/` - Notes for myself because I'm forgetful


## Plan
**Networking**
Using Tailscale to connect the nodes, "Personal" gives me 20 devices for a single user
which should be more than enough random cloud VMs for a personal cluster

Deploy MetalLB on a small instance (AWS or GCP) to act as ingress to the cluster, manage
ingresses using NGINX Ingress Controller

Certificates handled by cert-manager, haven't figured out hwo to handle DDNS yet

**Application Management**
Platform Applications (i.e. the cluster) will be handled by Flux, and all other apps using
Argo CD. Platform apps are separate in the case these apps fail they don't affect the
existing deployed applications.