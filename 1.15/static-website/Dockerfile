FROM nginx:1.15-alpine
LABEL maintainer "Patrick Baber <patrick.baber@servivum.com>"

COPY etc/default.conf /etc/nginx/conf.d/default.conf

# Change user of config files to allow editing for non-root user
RUN chown -R nginx:nginx /etc/nginx/conf.d

# Create and cleanup document root
RUN mkdir -p /var/www/ && rm -rf /var/www/*

WORKDIR /var/www/