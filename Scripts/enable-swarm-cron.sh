docker service create \
  --name swarm-cronjob \
  --mount type=bind,source=/var/run/docker.sock,destination=/var/run/docker.sock \
  crazymax/swarm-cronjob:latest
