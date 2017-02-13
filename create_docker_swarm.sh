#!/bin/sh

docker-machine \
create \
-d virtualbox \
consul-machine


docker $(docker-machine config consul-machine) run -d \
--restart=always \
-p "8500:8500" \
-h "consul" \
progrium/consul -server -bootstrap


docker-machine \
create \
-d virtualbox \
--swarm \
--swarm-master \
--swarm-discovery="consul://$(docker-machine ip \
consul-machine):8500" \
--engine-opt="cluster-store=consul://$(docker-machine ip \
consul-machine):8500" \
--engine-opt="cluster-advertise=eth1:2376" \
swarm-master


docker-machine \
create \
-d virtualbox \
--swarm \
--swarm-discovery="consul://$(docker-machine ip \
consul-machine):8500" \
--engine-opt="cluster-store=consul://$(docker-machine ip \
consul-machine):8500" \
--engine-opt="cluster-advertise=eth1:2376" \
swarm-node-01

docker-machine \
create \
-d virtualbox \
--virtualbox-disk-size "5000" \
--swarm \
--swarm-discovery="consul://$(docker-machine ip \
consul-machine):8500" \
--engine-opt="cluster-store=consul://$(docker-machine ip \
consul-machine):8500" \
--engine-opt="cluster-advertise=eth1:2376" \
swarm-node-02


eval "$(docker-machine env --swarm swarm-master)"


