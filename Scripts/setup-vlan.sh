#!/bin/bash
set -e

# ==== CONFIGURATION ====
NETWORK_NAME="swarm"
PARENT_IFACE="enp1s0f0"               # your NIC interface
SUBNET="192.168.0.0/20"           # your LAN subnet
GATEWAY="192.168.1.254"             # your LAN gateway
RANGE="192.168.1.0/20"          # available IPs for containers

# ==== SCRIPT ====
echo "=== Creating macvlan network '$NETWORK_NAME' for Swarm ==="

# Create local parent network interface (needed for host access to macvlan)
sudo ip link add macvlan-shim link $PARENT_IFACE type macvlan mode bridge
sudo ip addr add 192.168.1.250/32 dev macvlan-shim  # adjust an unused IP
sudo ip link set macvlan-shim up

# Create Docker macvlan overlay network for swarm
docker network create -d macvlan \
  --scope swarm \
  --attachable \
  --subnet=$SUBNET \
  --gateway=$GATEWAY \
  --ip-range=$RANGE \
  -o parent=$PARENT_IFACE \
  $NETWORK_NAME

echo "=== Macvlan network '$NETWORK_NAME' created ==="
docker network ls | grep $NETWORK_NAME
