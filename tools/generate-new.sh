#!/bin/sh

IDE[0]="vanilla"
IDE[1]="vsc"
IDE[2]="fleet"
IDE[3]="vsc-fleet"

OS[0]="debian"
OS[1]="ubuntu"
OS[2]="fedora"

cd ..

echo "Nom de l'image Docker"
read img

echo "Nom de la template Terraform"
read tpl 

cd docker

mkdir $img
cd $img

for ide in ${IDE[@]} ; do 
    mkdir $ide
    cd $ide
    for os in ${OS[@]} ; do
        mkdir $os
        touch $os/Dockerfile
    done
    cd ..
done

cd ../../template

mkdir $tpl

touch $tpl/main.tf