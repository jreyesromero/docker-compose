#!/bin/sh

# We create a consul-machine using virtualbox driver to be in charge of discovering services
docker-machine \
create \
-d virtualbox \
consul-machine

docker $(docker-machine config consul-machine) run -d \
--restart=always \
-p "8500:8500" \
-h "consul" \
progrium/consul -server -bootstrap

# Creation of node which acts as master of the swarm cluster.  It is attached to consul as discovery service
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

# creation of first worker in the swarm master. It is attached to consul as discovery service
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

# creation of second worker in the swarm master. It is attached to consul as discovery service
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

# Pointing docker CLI to swarm-master node
eval "$(docker-machine env --swarm swarm-master)"


