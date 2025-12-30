# Automatic Docker Service DNS Registration

This document explains how to automatically register Docker Swarm services in BIND9 DNS.

## Overview

The `dns-sync` service monitors Docker Swarm events and automatically updates BIND9 DNS records when services are:
- **Created** - A new DNS A record is added
- **Updated** - The DNS record is refreshed with the new VIP
- **Removed** - The DNS record is deleted

This eliminates manual DNS management for your Docker services.

## How It Works

### Architecture

```
Docker Swarm Manager
    ↓
Docker Events (service create/update/remove)
    ↓
dns-sync Container (monitors events)
    ↓
DNS UPDATE Protocol (RFC 2136)
    ↓
BIND9 (receives updates, modifies zone)
    ↓
Zone file (updated with new records)
```

### Technologies Used

- **DNS UPDATE (RFC 2136)**: Standard protocol for dynamic DNS updates
- **Docker SDK**: Monitors Swarm events in real-time
- **Python dnspython**: Sends DNS updates to BIND9
- **BIND9 Dynamic Zones**: Accepts UPDATE queries on localhost

## Setup Instructions

### 1. Build the dns-sync Image

Navigate to your bind9 directory and build:

```bash
cd ~/Docker/bind9

# Build the dns-sync image
docker build -f Dockerfile.dns-sync -t dns-sync:latest .
```

### 2. Deploy the Stack

```bash
docker stack deploy -c bind9-stack.yml bind9
```

This deploys:
- **bind9** service - BIND9 DNS server
- **dns-sync** service - Automatic service discovery

### 3. Verify Deployment

```bash
# Check services
docker service ls | grep bind9

# Check if dns-sync is running
docker service ps bind9_dns-sync

# View logs
docker service logs bind9_dns-sync
```

## Testing Automatic Registration

### 1. Deploy a Test Service

Create a simple test service:

```bash
cat > /tmp/test-stack.yml << 'EOF'
version: '3.8'

services:
  test-app:
    image: nginx:latest
    networks:
      - traefik_proxy

networks:
  traefik_proxy:
    external: true
EOF

docker stack deploy -c /tmp/test-stack.yml test-app
```

### 2. Watch dns-sync Logs

In one terminal, watch the logs:

```bash
docker service logs -f bind9_dns-sync
```

You should see:
```
Docker Event: service - create - test-app_test-app
✓ Service created: test-app_test-app (10.0.9.2)
DNS UPDATE: Adding test-app.itslit -> 10.0.9.2
✓ Successfully added DNS record for test-app.itslit
```

### 3. Query the New Service

```bash
# From a swarm node or external machine
nslookup test-app 192.168.1.50

# Or with dig for more details
dig @192.168.1.50 test-app.itslit

# Or use Docker container
docker run --rm --network traefik_proxy -it alpine \
  sh -c "apk add bind-tools && nslookup test-app bind9"
```

### 4. Update the Service

Update the service (e.g., scale it):

```bash
docker service update --replicas 3 test-app_test-app
```

Watch the logs - you'll see the service is re-synced.

### 5. Remove the Service

```bash
docker stack rm test-app
```

The dns-sync service will automatically remove the DNS record.

## DNS Record Naming Convention

Services are registered with a simple name mapping:

- Service name: `my_service` → DNS name: `my-service.itslit`
- Service name: `api_server` → DNS name: `api-server.itslit`
- Service name: `web.app` → DNS name: `web-app.itslit`

**Rules:**
- Underscores (`_`) are replaced with hyphens (`-`)
- Dots (`.`) are replaced with hyphens (`-`)
- Names are converted to lowercase
- Domain suffix (`.itslit`) is added automatically

## Configuration

### Environment Variables (in dns-sync service)

```yaml
environment:
  - BIND_SERVER=bind9          # Hostname/IP of BIND9 service
  - ZONE=itslit                # DNS zone name
  - DOMAIN=itslit              # Domain suffix for services
  - TTL=300                    # Time-to-Live in seconds
```

### Command-line Arguments

If running locally, the script supports:

```bash
python3 dns-sync.py \
  --bind-server 127.0.0.1 \
  --zone itslit \
  --domain itslit \
  --ttl 300 \
  --sync-on-start \
  --log-level INFO
```

| Argument | Default | Description |
|----------|---------|-------------|
| `--bind-server` | `127.0.0.1` | IP/hostname of BIND9 server |
| `--zone` | `itslit` | DNS zone name (must match BIND9 config) |
| `--domain` | `itslit` | Domain suffix for services |
| `--ttl` | `300` | Record time-to-live in seconds |
| `--sync-on-start` | False | Sync all existing services on startup |
| `--log-level` | `INFO` | Logging verbosity (DEBUG, INFO, WARNING, ERROR) |

## BIND9 Configuration

The `named.conf.local` must allow dynamic updates from localhost:

```
zone "itslit" {
    type master;
    file "/etc/bind/db.itslit";
    allow-update { localhost; 127.0.0.1; };
};
```

The dns-sync container connects to BIND9 via the Docker network, so "localhost" refers to the dns-sync container, which BIND9 sees as a network peer.

## Monitoring and Troubleshooting

### Check Service Status

```bash
# Check if dns-sync is running
docker service ps bind9_dns-sync

# View current logs
docker service logs bind9_dns-sync

# Follow logs in real-time
docker service logs -f bind9_dns-sync
```

### Common Issues

#### dns-sync container keeps restarting

Check logs:
```bash
docker service logs bind9_dns-sync
```

**Possible causes:**
- Cannot connect to Docker socket - Verify `/var/run/docker.sock` is mounted
- Cannot reach BIND9 - Verify BIND_SERVER hostname is correct
- Docker SDK version mismatch - Reinstall with correct version

#### DNS records not being created

1. **Verify dns-sync is running:**
   ```bash
   docker service ps bind9_dns-sync
   ```

2. **Check if service has VIP:**
   ```bash
   docker service inspect <service_name> | grep -A 20 VirtualIPs
   ```

3. **Manually test DNS update:**
   ```bash
   docker exec <dns-sync-container> \
     nsupdate -v << EOF
   server bind9
   zone itslit
   update add test.itslit 300 A 10.0.9.100
   send
   EOF
   ```

4. **Check BIND9 zone file:**
   ```bash
   docker exec <bind9-container> cat /etc/bind/db.itslit
   ```

#### High CPU usage

The dns-sync container monitors Docker events. High CPU usually means:
- Too many Docker events (lots of service activity)
- Event filtering issue
- Logging level set to DEBUG

Solution: Reduce log level or increase resource limits.

### Enable Debug Logging

To debug issues, change the log level to DEBUG:

Edit `bind9-stack.yml`:
```yaml
dns-sync:
  environment:
    - LOG_LEVEL=DEBUG
```

Then redeploy:
```bash
docker stack deploy -c bind9-stack.yml bind9
```

## Performance Considerations

### Resources

Default limits in the stack:
- **CPU**: 0.5 cores (max), 0.25 cores (reserved)
- **Memory**: 256 MB (max), 128 MB (reserved)

Adjust in `bind9-stack.yml` if needed:
```yaml
resources:
  limits:
    cpus: '1'
    memory: 512M
  reservations:
    cpus: '0.5'
    memory: 256M
```

### Scalability

- dns-sync is set to run on **1 manager node** (replicas: 1)
- One instance is sufficient for most environments
- Each DNS update takes ~100-500ms depending on zone size

## Limitations

1. **VIP-based registration**: Services are registered with their Virtual IP (stable endpoint), not individual container IPs
2. **Internal services only**: Only reachable internally on the overlay network initially (but DNS works from anywhere)
3. **No TTL caching coordination**: DNS clients cache records based on TTL; changes might not be immediately visible everywhere
4. **Single zone**: Currently set up for one zone (itslit); requires modification for multiple zones

## Advanced Usage

### Multiple Zones

To monitor multiple zones, modify the dns-sync service:

```yaml
dns-sync:
  environment:
    - BIND_SERVER=bind9
    - ZONE=itslit,example.com
    - DOMAIN=itslit
```

Then run dns-sync for each zone (requires separate script instances).

### Custom Service Labels

You could extend dns-sync to read service labels for custom DNS behavior:

```bash
docker service create --label dns.enabled=true --label dns.name=my-api my-service
```

See the dns-sync.py script for customization points.

### Integration with Traefik

Your services deployed with Traefik will:
1. Get a Traefik route (e.g., `https://service.itslit`)
2. Get a DNS entry (e.g., `service.itslit`)

This gives you both HTTP routing and DNS resolution.

## Stopping or Removing DNS Sync

To disable automatic registration but keep BIND9:

```bash
# Remove just the dns-sync service
docker service rm bind9_dns-sync

# Redeploy without dns-sync
docker stack deploy -c bind9-stack.yml bind9 --prune
```

To remove everything:

```bash
docker stack rm bind9
```

## Next Steps

1. **Deploy the stack**: `docker stack deploy -c bind9-stack.yml bind9`
2. **Monitor initial sync**: `docker service logs -f bind9_dns-sync`
3. **Deploy your first service** and watch it auto-register
4. **Test from clients**: Query the DNS server and verify records appear
5. **Configure client DNS**: Update your node and PC DNS settings to use BIND9

## Troubleshooting Checklist

- [ ] DNS sync container is running: `docker service ps bind9_dns-sync`
- [ ] BIND9 container is running: `docker service ps bind9_bind9`
- [ ] traefik_proxy network exists: `docker network ls | grep traefik`
- [ ] Docker socket is mounted: `docker exec <dns-sync> ls -la /var/run/docker.sock`
- [ ] Can query BIND9: `nslookup google.com 192.168.1.50` (should fallback to public DNS)
- [ ] Service has a VIP: `docker service inspect <service> | grep VirtualIPs`
- [ ] Check dns-sync logs: `docker service logs bind9_dns-sync`
