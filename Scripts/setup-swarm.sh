#!/bin/bash
set -e

### === USER CONFIGURATION ===
MANAGER_IP="192.168.1.10"          # IP of the manager node
PARENT_IFACE="eth0"                # Network interface on all nodes
SUBNET="192.168.1.0/24"            # LAN subnet
GATEWAY="192.168.1.1"              # LAN gateway
RANGE="192.168.1.200/28"           # IP range for containers
MACVLAN_NAME="swarm-macvlan"       # Network name
ROLE="$1"                          # "manager" or "worker"

### === FUNCTIONS ===

install_docker() {
  echo "=== Installing Docker Engine ==="
  sudo apt update -y && sudo apt install -y ca-certificates curl gnupg lsb-release
  sudo mkdir -p /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
    sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
  echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
    https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  sudo apt update
  sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
  sudo systemctl enable docker
  sudo systemctl start docker
  echo "=== Docker installed successfully ==="
}

init_swarm_manager() {
  echo "=== Initializing Docker Swarm as Manager ==="
  docker swarm init --advertise-addr $MANAGER_IP || true
  docker swarm join-token worker -q > /tmp/swarm_worker_token
  echo "Worker join token stored at /tmp/swarm_worker_token"
}

join_swarm_worker() {
  echo "=== Joining Docker Swarm as Worker ==="
  TOKEN=$(ssh $MANAGER_IP "docker swarm join-token worker -q")
  docker swarm join --token $TOKEN $MANAGER_IP:2377
}

setup_macvlan() {
  echo "=== Setting up Swarm Macvlan Network ==="
  docker network create -d macvlan \
    --scope swarm \
    --attachable \
    --subnet=$SUBNET \
    --gateway=$GATEWAY \
    --ip-range=$RANGE \
    -o parent=$PARENT_IFACE \
    $MACVLAN_NAME || true

  echo "Macvlan network '$MACVLAN_NAME' created."
  docker network ls | grep $MACVLAN_NAME
}

### === MAIN LOGIC ===

install_docker

if [[ "$ROLE" == "manager" ]]; then
  init_swarm_manager
  setup_macvlan
  echo "Manager setup complete."
elif [[ "$ROLE" == "worker" ]]; then
  join_swarm_worker
  echo "Worker setup complete."
else
  echo "Usage: $0 [manager|worker]"
  exit 1
fi
