# Create Shared Overlay Network for BIND9 and Traefik
docker network create -d overlay traefik-net
echo "=== Overlay network 'traefik-net' created ==="

# Deploy BIND9 Service
docker stack deploy -c ../bind9/bind9-stack.yml bind9
echo "=== BIND9 service deployed ==="

# Generate TLS Certificates for Traefik
mkdir -p ~/traefik/certs
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout ~/traefik/certs/traefik.key -out ~/traefik/certs/traefik.crt -subj "/CN=*.itslit"
echo "=== TLS certificates for Traefik generated ==="

# Deploy Traefik Service
docker stack deploy -c ../traefik/traefik-stack.yml traefik
echo "=== Traefik service deployed ==="

echo "=== Setup complete: BIND9 and Traefik are running on 'traefik-net' overlay network ==="

# Build Test App
cat >> whoami.yml << EOF
version: "3.9"

services:
  whoami:
    image: traefik/whoami
    networks:
      - traefik-net
    deploy:
      labels:
        - "traefik.enable=true"
        - "traefik.http.routers.whoami.rule=Host(`whoami.itslit`)"
        - "traefik.http.routers.whoami.entrypoints=websecure"
        - "traefik.http.services.whoami.loadbalancer.server.port=80"

networks:
  traefik-net:
    external: true
EOF

# Deploy Test App
docker stack deploy -c whoami.yml whoami
echo "=== Test app 'whoami' deployed ==="
echo "=== You can access the test app at https://whoami.itslit ==="