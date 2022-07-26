#!/bin/bash
sudo apt-get update && sudo apt-get upgrade
sudo curl -sfL https://get.k3s.io | \
    K3S_URL="${K3S_URL}" K3S_TOKEN="${K3S_TOKEN}" sh -s - \
    --node-name "$(cat /proc/sys/kernel/random/uuid | tail -c 12)" \
    --node-ip "$(curl icanhazip.com)"
sudo systemctl enable --now k3s-agent