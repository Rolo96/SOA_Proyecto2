############################################################
# Technological Institute of Costa Rica                    #
# Project2 CompraTec                                       #
# Teacher: Raul Madrigal Acuña                             #
# Students: Raul Arias, Rony Paniagua                      #
# Install docker machine and virtualbox                    #
############################################################

#Install docker machine
base=https://github.com/docker/machine/releases/download/v0.16.0 &&
curl -L $base/docker-machine-$(uname -s)-$(uname -m) >/tmp/docker-machine &&
sudo install /tmp/docker-machine /usr/local/bin/docker-machine

#install virtualbox
sudo apt-get update && sudo apt-get dist-upgrade && sudo apt-get autoremove
sudo apt-get -y install gcc make linux-headers-$(uname -r) dkms
wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -
wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | sudo apt-key add -
sudo sh -c 'echo "deb http://download.virtualbox.org/virtualbox/debian $(lsb_release -sc) contrib" >> /etc/apt/sources.list'
sudo apt-get update
sudo apt-get install virtualbox-5.2
VBoxManage -v
curl -O http://download.virtualbox.org/virtualbox/5.2.0/Oracle_VM_VirtualBox_Extension_Pack-5.2.0-118431.vbox-extpack
sudo VBoxManage extpack install Oracle_VM_VirtualBox_Extension_Pack-5.2.0-118431.vbox-extpack
VBoxManage list extpacks

