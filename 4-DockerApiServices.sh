############################################################
# Technological Institute of Costa Rica                    #
# Project2 CompraTec                                       #
# Teacher: Raul Madrigal Acuña                             #
# Students: Raul Arias, Rony Paniagua                      #
# Script to install services                               #
############################################################


# Copying the password file
docker-machine scp my_password.txt manager:/home/docker/
docker-machine scp my_password.txt worker1:/home/docker/

# Pulling images
eval $(docker-machine env manager)
docker-machine ssh manager 'cat ~/my_password.txt | docker login --username rolo1820 --password-stdin'
docker pull rolo1820/pythondocker
docker pull rolo1820/nodedocker
docker pull rolo1820/phpdocker
docker pull rolo1820/gatewaydocker

eval $(docker-machine env worker1)
docker-machine ssh worker1 'cat ~/my_password.txt | docker login --username rolo1820 --password-stdin'
docker pull rolo1820/pythondocker
docker pull rolo1820/nodedocker
docker pull rolo1820/phpdocker
docker pull rolo1820/gatewaydocker

eval $(docker-machine env manager)
docker service create --name phpdocker --network mongo --network bridge --replicas 2 rolo1820/phpdocker
docker service create --name nodedocker --network mongo --network bridge --replicas 2 rolo1820/nodedocker
docker service create --name pythondocker --network mongo --network bridge --replicas 2 rolo1820/pythondocker
docker service create --name gatewaydocker --network mongo --replicas 2 --publish 8086:8086 rolo1820/gatewaydocker
