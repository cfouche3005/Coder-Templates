#!/bin/sh

echo "Nom de l'image Docker"
read img

echo "Nom de la template Terraform"
read tpl 

cd docker

mkdir $img
mkdir $img/no-vsc
mkdir $img/vsc

mkdir $img/no-vsc/debian
mkdir $img/no-vsc/fedora
mkdir $img/no-vsc/ubuntu

mkdir $img/vsc/debian
mkdir $img/vsc/fedora
mkdir $img/vsc/ubuntu

touch $img/no-vsc/debian/Dockerfile
touch $img/no-vsc/fedora/Dockerfile
touch $img/no-vsc/ubuntu/Dockerfile

touch $img/vsc/debian/Dockerfile
touch $img/vsc/fedora/Dockerfile
touch $img/vsc/ubuntu/Dockerfile

cd ../template

mkdir $tpl

touch $tpl/main.tf