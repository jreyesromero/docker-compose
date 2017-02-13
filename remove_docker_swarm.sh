#!/bin/sh

docker-compose stop

docker-compose rm

eval "$(docker-machine env default)"

docker-machine stop swarm-node-01
docker-machine stop swarm-node-02

docker-machine rm swarm-node-01 -f
docker-machine rm swarm-node-02 -f

docker-machine stop swarm-master
docker-machine rm swarm-master -f

docker-machine stop consul-machine
docker-machine rm consul-machine -f

