# BIND9 DNS Service Setup for Docker Swarm

This guide walks you through deploying BIND9 (ISC BIND) as a DNS service on your 3-node Docker Swarm cluster.

## Overview

BIND9 is a widely-used, open-source DNS server. This setup configures it to:
- Run on your Docker Swarm (with constraints to run on manager nodes)
- Serve your internal domain (`itslit`)
- Provide DNS resolution for your services and nodes
- Use Docker Swarm secrets/configs for configuration management
- **Automatically register new Docker services via DNS sync** ✨

## Quick Features

- ✅ **Automatic Service Registration** - New Docker services are automatically added to DNS
- ✅ **Zero Manual Configuration** - Just deploy a service, DNS handles the rest
- ✅ **Dynamic Updates** - Service changes are reflected immediately in DNS
- ✅ **Fallback DNS** - External queries forwarded to public DNS
- ✅ **High Availability** - Restart policies ensure continuous operation

## Prerequisites

- Docker Swarm initialized with 3 nodes (1+ manager, 2+ workers or all managers)
- `traefik_proxy` overlay network exists
- Access to at least one manager node where you'll deploy

## Quick Setup

### 1. Configure Your IP Addresses

Edit the zone file to match your actual network:

```bash
nano ~/Docker/bind9/bind/etc/db.itslit
```

Update these entries with your actual IPs:
- `192.168.1.50` - Manager 1 (or primary DNS server)
- `192.168.1.51` - Manager 2 (or secondary DNS server)
- `192.168.1.52` - Worker 1

### 2. Customize Domain Name (Optional)

If your domain isn't `itslit`, replace all occurrences:

```bash
sed -i 's/itslit/yourdomain.com/g' ~/Docker/bind9/bind/etc/named.conf.local
sed -i 's/itslit/yourdomain.com/g' ~/Docker/bind9/bind/etc/db.itslit
```

### 3. Ensure Traefik Network Exists

```bash
docker network ls | grep traefik_proxy
```

If it doesn't exist, create it:

```bash
docker network create -d overlay traefik_proxy
```

### 4. Build the DNS Sync Image

The automatic service registration requires building the dns-sync container image:

```bash
cd ~/Docker/bind9
docker build -f Dockerfile.dns-sync -t dns-sync:latest .
```

### 5. Deploy BIND9 Stack

```bash
cd ~/Docker/bind9
docker stack deploy -c bind9-stack.yml bind9
```

This deploys both:
- **bind9** - BIND9 DNS server
- **dns-sync** - Automatic Docker service discovery

### 6. Verify Deployment

```bash
# Check service status
docker service ls | grep bind9

# Check running tasks
docker service ps bind9_bind9
docker service ps bind9_dns-sync

# View logs
docker service logs bind9_bind9
docker service logs bind9_dns-sync
```

## Automatic Service Registration (NEW!)

Your services are now automatically registered in DNS! No manual configuration needed.

### How It Works

1. You deploy a service: `docker service create my-api nginx`
2. The `dns-sync` service detects the event in real-time
3. Automatically updates BIND9 with a DNS record: `my-api.itslit`
4. Other services and clients can immediately query the service by name

### Quick Example

```bash
# Deploy a test service
docker service create --name web-app --network traefik_proxy nginx:latest

# Watch the logs - see the automatic registration
docker service logs -f bind9_dns-sync

# Query the new service
nslookup web-app 192.168.1.50
```

### Documentation

See [DNS-SYNC.md](DNS-SYNC.md) for complete documentation on automatic service registration, including:
- Testing and verification
- Configuration options
- Troubleshooting
- Advanced usage

## Configuration Files

### `named.conf.local`
- Defines your local zones (domains)
- Points to the zone database file
- Currently configured for `itslit` domain

### `db.itslit`
- Contains DNS records for your domain
- Includes A records for your manager and worker nodes
- Update the `Serial` number (2025122901) each time you modify this file
- Increment by 1 for each change (e.g., 2025122902)

## Testing DNS Resolution

### From a Swarm Node

```bash
# Install nslookup if needed (Alpine Linux)
docker run --rm -it alpine apk add bind-tools

# Query your BIND9 service
nslookup ns1.itslit 192.168.1.50
nslookup manager1.itslit 192.168.1.50
```

### From Your Local Machine (Optional)

If you want to use BIND9 as your DNS server:

1. Find the IP of a manager node running BIND9
2. Update your system DNS to point to that IP
3. Or use `nslookup` to query directly:

```bash
nslookup ns1.itslit 192.168.1.50
```

## Updating DNS Records

To add or modify DNS records:

1. Edit the zone file:
```bash
nano ~/Docker/bind9/bind/etc/db.itslit
```

2. **Increment the Serial number** (important!)
```
2025122901 → 2025122902
```

3. Redeploy:
```bash
docker stack deploy -c bind9-stack.yml bind9
```

4. Verify the update propagated:
```bash
docker service logs bind9_bind9
```

## Common Issues

### BIND9 Container Keeps Restarting

Check the logs:
```bash
docker service logs bind9_bind9
```

Common causes:
- **Zone file syntax error**: Validate with `named-checkzone`
- **Serial number not incremented**: BIND won't reload if serial stays the same
- **Permission issues**: Ensure bind directories have proper ownership

### DNS Queries Timing Out

```bash
# Verify BIND9 service is running
docker service ps bind9_bind9

# Check if port 53 is open on the manager node
sudo netstat -tulnp | grep :53

# Firewall rules may block DNS
sudo ufw allow 53/tcp
sudo ufw allow 53/udp
```

### Can't Resolve Internal Domain

1. Verify the zone file is properly mounted:
```bash
docker exec <container_id> cat /etc/bind/db.itslit
```

2. Check named.conf.local:
```bash
docker exec <container_id> cat /etc/bind/named.conf.local
```

3. Check BIND9 logs:
```bash
docker service logs bind9_bind9
```

## Adding Services to DNS

To add a new service (e.g., API endpoint), add an A record:

```
api         IN      A       192.168.1.50    ; Your service IP
```

Then:
1. Increment the serial number
2. Redeploy the stack

## Advanced: Multi-Node Bind Setup

For high availability with secondary nameservers:

1. Deploy multiple instances (remove `deploy.mode: global` constraint)
2. Configure secondary zones with `type slave`
3. Update `allow-transfer` in named.conf.local

See ISC BIND documentation for details.

## Volume Mounts

The stack uses three named volumes for persistence:

- **bind_etc**: Configuration files (/etc/bind)
- **bind_cache**: BIND cache data (/var/cache/bind)
- **bind_lib**: BIND library data (/var/lib/bind)

These persist data across container restarts but are tied to the node they're created on.

## Docker Swarm Constraints

The current configuration:
- Runs only on **manager nodes** (`node.role == manager`)
- Uses **host port binding** for port 53 (so no other service can use port 53 on that node)
- Has **restart policy** to automatically recover from failures

To allow running on worker nodes, remove the placement constraint.

## Security Considerations

- This setup provides no access control; add firewall rules
- Consider restricting zone transfers with `allow-transfer`
- Use DNSSEC for production environments
- Keep BIND9 image updated

## Useful Commands

```bash
# View stack details
docker stack ls
docker stack ps bind9

# Update configuration and redeploy
docker stack deploy -c bind9-stack.yml bind9

# Remove the service
docker stack rm bind9

# Check DNS resolution on host
host ns1.itslit 192.168.1.50
dig @192.168.1.50 ns1.itslit

# Validate zone file syntax
docker run --rm -v /path/to/db.itslit:/zone.file alpine \
    named-checkzone itslit /zone.file
```

## References

- [ISC BIND Documentation](https://www.isc.org/bind/)
- [Docker Service Deployment](https://docs.docker.com/engine/reference/commandline/service_create/)
- [DNS Fundamentals](https://www.cloudflare.com/en-gb/learning/dns/what-is-dns/)
