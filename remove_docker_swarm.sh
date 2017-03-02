#!/bin/sh

# Stops the microservice application deployed into the cluster with compose
docker-compose stop
docker-compose rm

# Pointing docker CLI to default machine (which has started docker daemon)
eval "$(docker-machine env default)"

# Stops workers
docker-machine stop swarm-node-01
docker-machine stop swarm-node-02

# Force to remove workers
docker-machine rm swarm-node-01 -f
docker-machine rm swarm-node-02 -f

# Stops and removes master node
docker-machine stop swarm-master
docker-machine rm swarm-master -f

# Stops and removes consul machine
docker-machine stop consul-machine
docker-machine rm consul-machine -f

