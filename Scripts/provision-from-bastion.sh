#!/bin/bash
set -euo pipefail

# Controller script to provision Docker Swarm from a bastion host
# Usage: ./provision_swarm_from_bastion.sh nodes.yml

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 nodes.yml"
  exit 1
fi

NODEFILE="$1"

if [[ ! -f "$NODEFILE" ]]; then
  echo "nodes.yml not found: $NODEFILE"
  exit 1
fi

# -----------------------------
# Minimal YAML parsing (works with the nodes.yml format above)
# -----------------------------
ssh_user=$(awk -F': ' '/^ssh_user:/{print $2; exit}' "$NODEFILE")
parent_iface=$(awk -F': ' '/^parent_iface:/{print $2; exit}' "$NODEFILE")
subnet=$(awk -F': ' '/^subnet:/{print $2; exit}' "$NODEFILE")
gateway=$(awk -F': ' '/^gateway:/{print $2; exit}' "$NODEFILE")
ip_range=$(awk -F': ' '/^ip_range:/{print $2; exit}' "$NODEFILE")
macvlan_name=$(awk -F': ' '/^macvlan_name:/{print $2; exit}' "$NODEFILE")
portainer_port=$(awk -F': ' '/^portainer_port:/{print $2; exit}' "$NODEFILE")

manager=$(awk '/^manager:/{flag=1; next} /^workers:/{flag=0} flag && NF {gsub(/^[ \-]+/,""); print; exit}' "$NODEFILE")
# Collect workers into array
readarray -t workers < <(awk '/^workers:/{flag=1; next} /^$/{if(flag) exit} flag && NF {gsub(/^[ \-]+/,""); print}' "$NODEFILE")

if [[ -z "$ssh_user" || -z "$manager" ]]; then
  echo "ssh_user or manager is missing in nodes.yml"
  exit 1
fi

echo "Controller will use SSH user: $ssh_user"
echo "Manager: $manager"
echo "Workers: ${workers[*]:-none}"
echo "Parent iface: $parent_iface, subnet: $subnet, gateway: $gateway, ip_range: $ip_range, macvlan: $macvlan_name"

# -----------------------------
# Remote helper: installs Docker and ensures service is running
# This will be executed on every node via SSH (bash -s)
# -----------------------------
install_script() {
cat <<'REMOTE_SCRIPT'
set -euo pipefail
echo "=== Updating system and installing prerequisites ==="
sudo apt update -y
sudo apt install -y ca-certificates curl gnupg lsb-release

echo "=== Adding Docker GPG key & repo ==="
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

sudo systemctl enable docker
sudo systemctl start docker
echo "=== Docker installed and started ==="
docker --version
REMOTE_SCRIPT
}

# -----------------------------
# Run the install script on each host
# -----------------------------
remote_exec() {
  local host="$1"
  echo "-> Running install script on $host"
  ssh -o BatchMode=yes -o StrictHostKeyChecking=no "${ssh_user}@${host}" "bash -s" <<'SSHEND'
'"$(install_script 2>/dev/null || true)"'
SSHEND
}

# Alternative remote_exec method that preserves heredoc content reliably:
remote_exec_copy() {
  local host="$1"
  echo "-> Installing Docker on $host"
  ssh -o BatchMode=yes -o StrictHostKeyChecking=no "${ssh_user}@${host}" 'bash -s' < <(install_script)
}

# Use the copy variant for better heredoc delivery
echo "=== Installing Docker on all nodes ==="
remote_exec_copy "$manager"
for w in "${workers[@]}"; do
  if [[ -n "$w" ]]; then
    remote_exec_copy "$w"
  fi
done

# -----------------------------
# Initialize swarm on manager
# -----------------------------
echo "=== Initializing Swarm on manager ($manager) ==="
# get manager IP on the parent_iface remote side (we'll detect it there)
MANAGER_IP=$(ssh -o StrictHostKeyChecking=no "${ssh_user}@${manager}" "ip -4 addr show ${parent_iface} | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | head -n1")
if [[ -z "$MANAGER_IP" ]]; then
  echo "Could not detect manager IP on interface $parent_iface. Exiting."
  exit 1
fi

ssh -o StrictHostKeyChecking=no "${ssh_user}@${manager}" "sudo docker swarm init --advertise-addr ${MANAGER_IP} || true"
echo "Swarm init attempted. Manager IP: $MANAGER_IP"

# -----------------------------
# Get worker join token from manager
# -----------------------------
echo "=== Retrieving worker join token from manager ==="
SWARM_TOKEN=$(ssh -o StrictHostKeyChecking=no "${ssh_user}@${manager}" "sudo docker swarm join-token worker -q")
if [[ -z "$SWARM_TOKEN" ]]; then
  echo "Failed to obtain swarm join token"
  exit 1
fi
echo "Token obtained."

# -----------------------------
# Join workers
# -----------------------------
echo "=== Joining workers to swarm ==="
for w in "${workers[@]}"; do
  if [[ -z "$w" ]]; then
    continue
  fi
  echo "-> Worker $w joining..."
  ssh -o StrictHostKeyChecking=no "${ssh_user}@${w}" "sudo docker swarm join --token ${SWARM_TOKEN} ${MANAGER_IP}:2377 || true"
done

# -----------------------------
# Setup macvlan network on manager
# -----------------------------
echo "=== Creating macvlan network on manager ==="
ssh -o StrictHostKeyChecking=no "${ssh_user}@${manager}" "sudo docker network create -d macvlan --scope swarm --attachable --subnet=${subnet} --gateway=${gateway} --ip-range=${ip_range} -o parent=${parent_iface} ${macvlan_name} || true"

# -----------------------------
# Deploy test services (Nginx + Portainer) on manager
# -----------------------------
echo "=== Deploying test services (nginx & portainer) ==="
ssh -o StrictHostKeyChecking=no "${ssh_user}@${manager}" bash <<EOF
set -e
sudo docker service create --name test-nginx --network ${macvlan_name} --replicas 3 --publish published=8080,target=80 nginx:alpine || true
sudo docker volume create portainer_data >/dev/null || true
sudo docker service create \
  --name portainer \
  --network ${macvlan_name} \
  --publish published=${portainer_port},target=9000 \
  --replicas 1 \
  --constraint 'node.role==manager' \
  --mount type=volume,source=portainer_data,target=/data \
  --mount type=bind,source=/var/run/docker.sock,target=/var/run/docker.sock \
  portainer/portainer-ce:latest || true
EOF

echo "=== Provisioning complete ==="
echo "Manager: ${manager} (${MANAGER_IP})"
echo "Portainer should be available at: http://${MANAGER_IP}:${portainer_port} (allow a minute for container to start)"
echo "Check on manager: sudo docker node ls; sudo docker service ls; sudo docker network ls"
