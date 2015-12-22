FROM debian:jessie

# Nginx with Google Pagespeed module
MAINTAINER Patrick Baber <patrick.baber@servivum.com>

# Versions
ENV NGINX_VERSION "1.9.9"
ENV NGINX_PAGESPEED_VERSION "1.10.33.2"
ENV BUILD_DEPS 'build-essential ca-certificates git libpcre3 libpcre3-dev unzip wget zlib1g-dev'

# @TODO: Integrate key verification

# Load build essentials
RUN apt-get update && apt-get install -y $BUILD_DEPS && \
	rm -rf /var/lib/apt/lists/* && \
	mkdir -p /usr/src/nginx

# Load Pagespeed module, PSOL and nginx
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
	make install

# @TODO: Use specific version of h5bp nginx confs
# Copy h5bp nginx conf into nginx conf subfolder
RUN cd /usr/src/nginx && \
	wget https://github.com/h5bp/server-configs-nginx/archive/master.zip && \
	unzip master.zip && \
	cp -r server-configs-nginx-master/h5bp/ /etc/nginx/h5bp

# @TODO: Integrate Let's Encrypt!

# @TODO: Optimize image size
# Clean
RUN rm -rf /usr/src/nginx
#	apt-get purge -y ca-certificates git libpcre3 libpcre3-dev zlib1g-dev
#	apt-get clean autoclean && \
#	apt-get autoremove -y

# @TODO: Add nginx logs to docker log collector
# forward request and error logs to docker log collector
RUN mkdir -p /var/log/nginx && \
    ln -sf /dev/stdout /var/log/nginx/access.log && \
    ln -sf /dev/stderr /var/log/nginx/error.log

VOLUME ["/var/cache/nginx"]

EXPOSE 80 443

CMD ["nginx", "-g", "daemon off;"]