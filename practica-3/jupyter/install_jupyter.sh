#!/bin/bash

sudo apt-get update
sudo apt-get install -y python3 python3-pip
sudo pip3 install notebook # -H
mkdir -p /home/vagrant/notebooks
chown vagrant:vagrant /home/vagrant/notebooks
