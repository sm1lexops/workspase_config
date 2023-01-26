#!/bin/bash -ex

sudo dnf update && sudo dnf -y upgrade

sudo dnf -y install yum-utils

sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

sudo dnf update

sudo dnf -y install docker-ce docker-ce-cli containerd.io

sudo systemctl start docker && sudo systemctl enable docker
