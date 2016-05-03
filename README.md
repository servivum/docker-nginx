![nginx 1.10.0](https://img.shields.io/badge/nginx-1.10.0-brightgreen.svg?style=flat-square) [![License MIT](https://img.shields.io/badge/license-MIT-blue.svg?style=flat-square)](https://opensource.org/licenses/MIT) [![Travis](https://img.shields.io/travis/servivum/docker-nginx.svg?style=flat-square)](https://travis-ci.org/servivum/docker-nginx)

# Nginx Docker Image with Useful Tools

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

- `1.10`, `1`, `latest` [(Dockerfile)](https://github.com/servivum/docker-nginx)

## Usage

To pass your own server block configuration, mount a file with conf 
extension from your host system into `/etc/nginx/conf.d/`, e.g. 
`docker run -P -v /host-folder/:/etc/nginx/conf.d`.
