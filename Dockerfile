FROM alpine:edge
MAINTAINER Paul Adams <paul@baggerspion.net>

# Set the NC version
ENV NC_VERSION 12.0.2

# Add the testing repo
RUN echo 'http://dl-cdn.alpinelinux.org/alpine/edge/testing' >> /etc/apk/repositories

# Install Nextcloud
RUN apk update && \
    apk upgrade && \
    apk add --no-cache \
    	curl \
	nginx \
	php7-apcu \
	php7-bz2 \
	php7-ctype \ 
    	php7-curl \
	php7-dev \
	php7-dom \
	php7-exif \
	php7-fpm \
    	php7-gd \
	php7-gmagick \
	php7-iconv \
    	php7-intl \
    	php7-json \
	php7-ldap \
    	php7-mbstring \
    	php7-mcrypt \
	php7-mysqli \
	php7-openssl \
	php7-opcache \
	php7-pdo_mysql \
	php7-pdo_pgsql \
	php7-pgsql \
	php7-redis \
	php7-session \
	php7-simplexml \
	php7-sqlite3 \
    	php7-xml \
	php7-xmlreader \
	php7-xmlwriter \
    	php7-zip \
	php7-zlib && \

    adduser -D -u 1000 -g 'www' www && \
    mkdir /www && \
    chown -R www:www /var/lib/nginx && \
    chown -R www:www /www && \
    curl -o nc.tar.bz2 -fSL -0 https://download.nextcloud.com/server/releases/nextcloud-$NC_VERSION.tar.bz2 && \
    tar -xjf nc.tar.bz2 && \
    mv nextcloud/* /www && \
    rm -rf nextcloud /var/cache/apk/* /tmp/* nc.tar.bz2

COPY nginx.conf /etc/nginx/nginx.conf
RUN { \
    echo 'opcache.memory_consumption=128'; \
    echo 'opcache.interned_strings_buffer=8'; \
    echo 'opcache.max_accelerated_files=4000'; \
    echo 'opcache.revalidate_freq=60'; \
    echo 'opcache.fast_shutdown=1'; \
    echo 'opcache.enable_cli=1'; \
  } >> /etc/php7/conf.d/00_opcache.ini

# The fun starts here!
COPY nextcloud-entrypoint.sh /
ENTRYPOINT ["/nextcloud-entrypoint.sh"]