#!/bin/bash
set -ev

echo "Building and running image ..."
docker build -t nginx .
docker run -d -P --name nginx nginx

echo "Waiting some time, because the process manager inside the container runs async to the docker run command ..."
sleep 10

echo "Checking if container is running ..."
docker ps | grep nginx

echo "Checking existence of some binaries and packages ..."
docker exec nginx which nginx
docker exec nginx ps aux | grep nginx
docker exec nginx 2>&1 nginx -V | tr -- - '\n' | grep _pagespeed
docker exec nginx ls -al /etc/nginx/h5bp
docker exec nginx which letsencrypt
docker exec nginx which htpasswd