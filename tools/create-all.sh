#!/bin/sh

cd ../template

for template in */ ; do 
    cd $template
    coder templates create --yes --default-ttl 4h0m0s
    cd ..
done