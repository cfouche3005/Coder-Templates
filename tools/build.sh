#!/bin/sh

cd ..

echo "Nom de l'image Docker à construire"
read img

cd docker/$img

for flavour in */ ; do
    cd $flavour
    for os in */ ; do
        mode=$( tail -n 1 $os/Dockerfile )
        if [ $mode = "#a" ] ; then
        sed -i "s+#a+#b+g" $os/Dockerfile
        else
        sed -i "s+#b+#a+g" $os/Dockerfile
        fi
    done
    cd ..
done