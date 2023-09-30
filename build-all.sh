#!/bin/bash

docker buildx build --push --platform amd64 --platform arm64  -t cf3005/ctdc-base:debian  ./debian

docker buildx build --push --platform amd64 --platform arm64  -t cf3005/ctdc-base:ubuntu  ./ubuntu

docker buildx build --push --platform amd64 --platform arm64  -t cf3005/ctdc-base:fedora  ./fedora
