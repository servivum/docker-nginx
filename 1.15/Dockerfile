FROM nginx:1.15-alpine
LABEL maintainer "Patrick Baber <patrick.baber@servivum.com>"

COPY docker/nginx/etc/default.conf /etc/nginx/conf.d/default.conf

# Create and cleanup document root
RUN mkdir -p /var/www/ && rm -rf /var/www/*

WORKDIR /var/www/