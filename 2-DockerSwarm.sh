############################################################
# Technological Institute of Costa Rica                    #
# Project2 CompraTec                                       #
# Teacher: Raul Madrigal Acuña                             #
# Students: Raul Arias, Rony Paniagua                      #
# Script docker swarm                                      #
############################################################

#!/bin/bash
reset
# Create two docker-machines in virtualbox and create a cluster of docker swarm with one machine as manager and another as worker


# Create the nodes
echo "Creating the nodes"
for node in "manager" "worker1"; do
	docker-machine create -d virtualbox $node
done

# Storing the ip address of the manager
MANAGER_IP=$(docker-machine ip manager)

# Connecting with the managaer and starting the swarm
eval $(docker-machine env manager)
echo "Starting the swarm"
docker swarm init --advertise-addr $MANAGER_IP
docker node update --label-add administrador="Raul-Rony" manager

# Storing the tokens
MANAGER_TOKEN=$(docker swarm join-token -q manager)
WORKER_TOKEN=$(docker swarm join-token -q worker)

# Adding each worker to the swarm
for node in "worker1";do
	WORKER_IP=$(docker-machine ip $node)
	eval $(docker-machine env $node)
	echo "Joining the worker to the swarm"
	docker swarm join --token $WORKER_TOKEN --advertise-addr $WORKER_IP $MANAGER_IP:2377
done

# Verifying swarm nodes
eval $(docker-machine env manager)
docker node ls
