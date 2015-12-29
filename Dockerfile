# Nginx Docker Image + Pagespeed + H5BP Configs + Let's Encrypt!

FROM servivum/debian:jessie
MAINTAINER Patrick Baber <patrick.baber@servivum.com>

# Versions
ENV NGINX_VERSION "1.9.9"
ENV NGINX_PAGESPEED_VERSION "1.10.33.2"

# Load build essentials
RUN apt-get update && apt-get install -y \
    build-essential \
    libpcre3 \
    libpcre3-dev \
    libreadline6 \
    zlib1g-dev \
    && \
	mkdir -p /usr/src/nginx

# Load Pagespeed module, PSOL and nginx
# @TODO: Integrate key verification
RUN cd /usr/src/nginx && \
	wget https://github.com/pagespeed/ngx_pagespeed/archive/release-${NGINX_PAGESPEED_VERSION}-beta.zip -O release-${NGINX_PAGESPEED_VERSION}-beta.zip && \
	unzip release-${NGINX_PAGESPEED_VERSION}-beta.zip && \
	cd ngx_pagespeed-release-${NGINX_PAGESPEED_VERSION}-beta/ && \
	wget https://dl.google.com/dl/page-speed/psol/${NGINX_PAGESPEED_VERSION}.tar.gz && \
	tar -xzvf ${NGINX_PAGESPEED_VERSION}.tar.gz

# Load and compile nginx with Pagespeed module
RUN cd /usr/src/nginx && \
	wget http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz && \
	tar -xvzf nginx-${NGINX_VERSION}.tar.gz && \
	cd nginx-${NGINX_VERSION}/ && \
	./configure --add-module=/usr/src/nginx/ngx_pagespeed-release-${NGINX_PAGESPEED_VERSION}-beta \
		--sbin-path=/usr/sbin/nginx \
		--conf-path=/etc/nginx/nginx.conf && \
	make && \
	make install && \
	rm -rf /usr/src/nginx

# Copy h5bp nginx conf into nginx conf subfolder
# @TODO: Use specific version of h5bp nginx confs
RUN cd /usr/src/nginx && \
	wget https://github.com/h5bp/server-configs-nginx/archive/master.zip -O server-configs-nginx.zip && \
	unzip server-configs-nginx.zip && \
	cp -r server-configs-nginx-master/h5bp/ /etc/nginx/h5bp

# Add nginx to supervisor
COPY etc/supervisor/conf.d/nginx.conf /etc/supervisor/conf.d/nginx.conf

# Download Let's Encrypt!
# @TODO: Use specific version of Let's Encrypt!
RUN cd /usr/src/nginx && \
    wget https://github.com/letsencrypt/letsencrypt/archive/master.zip -O letsencrypt.zip && \
    unzip letsencrypt.zip && \
    cp -r letsencrypt-master/ /etc/letsencrypt/ && \
    ln -s /etc/letsencrypt/letsencrypt-auto /usr/local/bin/letsencrypt

# Clean up
# @TODO: Optimize image size
RUN apt-get purge -y -f \
	build-essential \
	&& \
	apt-get clean autoclean && \
	apt-get autoremove -y && \
	rm -rf /var/lib/apt/lists/*

# forward request and error logs to docker log collector
# @TODO: Add nginx logs to docker log collector
RUN mkdir -p /var/log/nginx && \
    ln -sf /dev/stdout /var/log/nginx/access.log && \
    ln -sf /dev/stderr /var/log/nginx/error.log

VOLUME ["/var/cache/nginx"]
WORKDIR /var/www
EXPOSE 80 443
CMD ["/usr/bin/supervisord"]