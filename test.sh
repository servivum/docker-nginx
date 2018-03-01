#!/bin/bash
set -ev

echo "Building images…"
docker-compose -f docker-compose.build.yml build --no-cache --pull

#echo "Creating nginx config for server block…"
#cat > default.conf <<EOF
#server {
#    listen 80;
#    server_name _;
#    root /usr/local/nginx/html;
#    index index.html;
#}
#EOF

#echo "Running image…"
#docker run -d -P -v $(pwd)/default.conf:/etc/nginx/conf.d/default.conf --name nginx servivum/nginx

#echo "Waiting some time, because the process manager inside the container runs async to the docker run command…"
#sleep 10

#echo "Checking if container is running…"
#docker ps | grep nginx

#echo "Checking existence of some binaries and packages…"
#docker exec nginx which nginx
#docker exec nginx ps aux | grep nginx
#docker exec nginx 2>&1 nginx -V | tr -- - '\n' | grep _pagespeed
#docker exec nginx ls -al /etc/nginx/h5bp
#docker exec nginx which letsencrypt
#docker exec nginx which htpasswd

#echo "Getting IP address of external docker-machine or using localhost instead…"
#if ! docker-machine ip; then
#    export IP="127.0.0.1"
#else
#    export IP=$(docker-machine ip)
#fi
#echo "IP: $IP"

#export PORT=$(docker inspect --format='{{(index (index .NetworkSettings.Ports "80/tcp") 0).HostPort}}' nginx)
#echo "PORT: $PORT"
#docker ps

#echo "Connecting to nginx via port 80…"
#curl -f http://${IP}:${PORT}/

#echo "Removing nginx config for server block…"
#rm default.conf