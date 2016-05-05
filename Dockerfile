# Nginx Docker Image + Pagespeed + H5BP Configs + Let's Encrypt!

FROM servivum/debian:jessie
MAINTAINER Patrick Baber <patrick.baber@servivum.com>

# Versions
# URL: http://nginx.org/en/download.html
ENV NGINX_VERSION "1.10.0"
ENV NGINX_PGP_KEY_ID "A1C052F8"
# URL: https://developers.google.com/speed/pagespeed/module/build_ngx_pagespeed_from_source
ENV NGINX_PAGESPEED_VERSION "1.11.33.1"

# Load build essentials
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    libpcre3 \
    libpcre3-dev \
    libreadline6 \
    zlib1g-dev \
    && \
    mkdir -p /usr/src/nginx && \

# Load Pagespeed module, PSOL and nginx
    cd /usr/src/nginx && \
	wget https://github.com/pagespeed/ngx_pagespeed/archive/release-${NGINX_PAGESPEED_VERSION}-beta.zip -O release-${NGINX_PAGESPEED_VERSION}-beta.zip && \
	unzip release-${NGINX_PAGESPEED_VERSION}-beta.zip && \
	cd ngx_pagespeed-release-${NGINX_PAGESPEED_VERSION}-beta/ && \
	wget https://dl.google.com/dl/page-speed/psol/${NGINX_PAGESPEED_VERSION}.tar.gz && \
	tar -xzvf ${NGINX_PAGESPEED_VERSION}.tar.gz && \

# Load and compile nginx with Pagespeed module
    cd /usr/src/nginx && \
	wget http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz && \
	wget http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz.asc && \
	gpg --keyserver x-hkp://pool.sks-keyservers.net --recv-keys ${NGINX_PGP_KEY_ID} && \
	gpg --verify nginx-${NGINX_VERSION}.tar.gz.asc nginx-${NGINX_VERSION}.tar.gz && \
	tar -xvzf nginx-${NGINX_VERSION}.tar.gz && \
	cd nginx-${NGINX_VERSION}/ && \
	./configure --add-module=/usr/src/nginx/ngx_pagespeed-release-${NGINX_PAGESPEED_VERSION}-beta \
		--sbin-path=/usr/sbin/nginx \
		--conf-path=/etc/nginx/nginx.conf && \
	make && \
	make install && \
	mkdir -p /var/log/nginx && \

# Clean up
	rm -rf /usr/src/nginx && \
    apt-get purge -y -f \
    build-essential \
    && \
    apt-get clean autoclean && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*

# Add nginx basic conf
COPY etc/nginx/nginx.conf /etc/nginx/nginx.conf

# Add nginx to supervisor
COPY etc/supervisor/conf.d/nginx.conf /etc/supervisor/conf.d/nginx.conf

# Copy h5bp nginx conf into nginx conf subfolder
RUN mkdir -p /usr/src/nginx && \
    cd /usr/src/nginx && \
	wget https://github.com/h5bp/server-configs-nginx/archive/master.zip -O server-configs-nginx.zip && \
	unzip server-configs-nginx.zip && \
	cp -r server-configs-nginx-master/h5bp/ /etc/nginx/h5bp && \
	rm -rf /usr/src/nginx

# Download Let's Encrypt!
RUN mkdir -p /usr/src/nginx && \
    cd /usr/src/nginx && \
    wget https://github.com/letsencrypt/letsencrypt/archive/master.zip -O letsencrypt.zip && \
    unzip letsencrypt.zip && \
    cp -r letsencrypt-master/ /etc/letsencrypt/ && \
    ln -s /etc/letsencrypt/letsencrypt-auto /usr/local/bin/letsencrypt && \
    rm -rf /usr/src/nginx

# Load apache2-utils because htpasswd is included.
# @TODO: Is there a way to get only htpasswd without further apache stuff?
RUN apt-get update && apt-get install -y  --no-install-recommends apache2-utils

VOLUME ["/var/cache/nginx"]
WORKDIR /var/www
EXPOSE 80 443
CMD ["/usr/bin/supervisord"]
