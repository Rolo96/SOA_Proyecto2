############################################################
# Technological Institute of Costa Rica                    #
# Project2 CompraTec                                       #
# Teacher: Raul Madrigal Acuña                             #
# Students: Raul Arias, Rony Paniagua                      #
# Script mongo cluster                                     #
############################################################

# Setting labels, volumes, and network in the manager
eval $(docker-machine env manager)
docker node update --label-add mongo.replica=1 $(docker node ls -q -f name=manager)
docker node update --label-add mongo.replica=2 $(docker node ls -q -f name=worker1)
docker network create --driver overlay --internal mongo
docker volume create --name mongodata1
docker volume create --name mongoconfig1

# Setting volumes in the worker
eval $(docker-machine env worker1)
docker volume create --name mongodata2
docker volume create --name mongoconfig2

# creating the services
eval $(docker-machine env manager)
docker service create --replicas 1 --network mongo --mount type=volume,source=mongodata1,target=/data/db --mount type=volume,source=mongoconfig1,target=/data/configdb --constraint 'node.labels.mongo.replica == 1' --name mongo1 mongo:3.2 mongod --replSet mongoReplSet
docker service create --replicas 1 --network mongo --mount type=volume,source=mongodata2,target=/data/db --mount type=volume,source=mongoconfig2,target=/data/configdb --constraint 'node.labels.mongo.replica == 2' --name mongo2 mongo:3.2 mongod --replSet mongoReplSet

# creating the replica set
eval $(docker-machine env manager)
docker exec -it $(docker ps -qf label=com.docker.swarm.service.name=mongo1) mongo --eval 'rs.initiate({ _id: "mongoReplSet", members: [{ _id: 1, host: "mongo1:27017" }, { _id: 2, host: "mongo2:27017" }], settings: { getLastErrorDefaults: { w: "majority", wtimeout: 30000 }}})'
