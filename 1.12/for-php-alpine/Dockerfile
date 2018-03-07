FROM nginx:1.12-alpine
LABEL maintainer "Patrick.Baber <patrick.baber@servivum.com>"

# Copy nginx VHost config for PHP
COPY etc/default.conf /etc/nginx/conf.d/default.conf

# Create project root
RUN mkdir -p /var/www/html