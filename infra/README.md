# Infra
Setting up the Kubernetes cluster using as many free tier resources from cloud providers as I can because I am cheap and don't like paying for stuff.

**Software Tools**
* `terraform` - Create the nodes, and add them to the ansible inventories
* `ansible` - Configure the nodes to connect to the cluster
* `platform-apps` - Flux deploying apps to Kubernetes, makes managing other apps easier


**Networking**
Using Tailscale to connect the nodes, "Personal" gives me 20 devices for a single user
which should be more than enough random cloud VMs for a personal cluster