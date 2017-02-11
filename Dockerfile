FROM alpine:edge
MAINTAINER Paul Adams <paul@baggerspion.net>

# Set the NC version
ENV NC_VERSION 11.0.1

# Add the testing repo
RUN echo 'http://dl-cdn.alpinelinux.org/alpine/edge/testing' >> /etc/apk/repositories

# Install Nextcloud
RUN apk update && \
    apk upgrade && \
    apk add --no-cache \
    	apache2 \ 
    	apache2-utils \
    	curl \
    	php5-imagick \
    	php7-apache2 \
	php7-apcu \
	php7-bz2 \
	php7-ctype \ 
    	php7-curl \
	php7-dev \
	php7-dom \
	php7-exif \
    	php7-gd \
	php7-iconv \
    	php7-intl \
    	php7-json \
	php7-ldap \
    	php7-mbstring \
    	php7-mcrypt \
	php7-memcached \
	php7-mysqli \
	php7-openssl \
	php7-opcache \
	php7-pdo_mysql \
	php7-pdo_pgsql \
	php7-pgsql \
	php7-redis \
	php7-session \
	php7-sqlite3 \
    	php7-xml \
	php7-xmlreader \
    	php7-zip \
	php7-zlib && \

    curl -o nc.tar.bz2 -fSL -0 https://download.nextcloud.com/server/releases/nextcloud-$NC_VERSION.tar.bz2 && \
    tar -xjf nc.tar.bz2 && \
    mv nextcloud /var/www/localhost/htdocs && \
    chown -R apache.www-data /var/www/localhost/htdocs/nextcloud && \

    rm -rf /var/cache/apk/* /tmp/*

# Configure Apache
RUN mkdir -p /run/apache2 && \
    sed -i 's/^#ServerName.*/ServerName nextcloud/' /etc/apache2/httpd.conf && \
    sed -i 's/^#LoadModule rewrite_module/LoadModule rewrite_module/' /etc/apache2/httpd.conf

COPY nextcloud.conf /etc/apache2/conf.d

# Configure PHP
RUN { \
    echo 'opcache.memory_consumption=128'; \
    echo 'opcache.interned_strings_buffer=8'; \
    echo 'opcache.max_accelerated_files=4000'; \
    echo 'opcache.revalidate_freq=60'; \
    echo 'opcache.fast_shutdown=1'; \
    echo 'opcache.enable_cli=1'; \
  } >> /etc/php7/conf.d/00_opcache.ini

# The fun starts here!
ENTRYPOINT ["apachectl", "-D", "FOREGROUND"]