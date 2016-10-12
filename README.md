![nginx 1.11.5](https://img.shields.io/badge/nginx-1.11.5-brightgreen.svg?style=flat-square) ![PageSpeed 1.11.33.3](https://img.shields.io/badge/PageSpeed-1.11.33.3-brightgreen.svg?style=flat-square) [![License MIT](https://img.shields.io/badge/license-MIT-blue.svg?style=flat-square)](https://opensource.org/licenses/MIT) [![Travis](https://img.shields.io/travis/servivum/docker-nginx.svg?style=flat-square)](https://travis-ci.org/servivum/docker-nginx)

# Nginx Docker Image

Dockerfile for creating Nginx image with useful tools, e.g. Google Pagespeed module, Nginx config templates, etc. See 
[Docker Hub](https://hub.docker.com/r/servivum/nginx) for more details about the image.

## What's inside?

- Servivum Debian Base: [Read more](https://github.com/servivum/docker-debian)
- nginx: Modern webserver and reverse proxy
- Google Pagespeed Module: nginx module for speeding up your website by using handy filters.
- H5BP Nginx Server Configs: Collection of nginx configuration snippets.
- Let's Encrypt: Secure your project for free. 
- htpasswd: Create credential files for protected URLs.

## Supported Tags

- `1.11`, `1`, `latest` [(Dockerfile)](https://github.com/servivum/docker-nginx)

## Usage

### Basic

Start the container with a port mapping like this to see the nginx welcome page:

``bash
docker run -p 80:80 servivum/nginx
``

### Own nginx Configuration

To pass your own nginx configuration, place a file `/etc/nginx/nginx.conf` inside the container 
by volume or your own Dockerfile which extends the original one.

``bash
docker run -p 80:80 -v /host-folder/nginx.conf:/etc/nginx/nginx.conf servivum/nginx
``

### Own Server Block/Virtual Host

By default the nginx.conf includes `/etc/nginx/conf.d/*.conf` files for configuring nginx server blocks.
To pass your own server block, place a file with `.conf` extension inside the container by volume or your own Dockerfile 
which extends the original one. 

``bash
docker run -p 80:80 -v /host-folder/:/etc/nginx/conf.d servivum/nginx
``