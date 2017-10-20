FROM php:7.0.24-fpm
MAINTAINER Tom Richards <tom.r@delegator.com>

# Pre-repository setup: Add support for HTTPS repositories
RUN apt-get update -q
RUN apt-get install -qy apt-transport-https

# Repository: Yarn package manager
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
COPY ./config/etc/apt/sources.list.d/yarn.list /etc/apt/sources.list.d/yarn.list

# Repository: Node.js 4
RUN curl --silent https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add -
COPY ./config/etc/apt/sources.list.d/nodesource.list /etc/apt/sources.list.d/nodesource.list

# Install packages
RUN apt-get update -q
RUN apt-get upgrade -qy
RUN DEBIAN_FRONTEND=noninteractive apt-get install -qy \
    bash supervisor \
    build-essential hardening-wrapper \
    curl htop git vim wget \
    nginx-extras mysql-client redis-tools nullmailer \
    nodejs yarn \
    ruby ruby-dev rake \
    libxml2-utils \
    libcurl4-openssl-dev \
    libfreetype6-dev \
    libicu-dev \
    libjpeg62-turbo-dev \
    libmcrypt-dev \
    libpng12-dev \
    libxml2-dev libxslt1-dev \
    zlib1g-dev
RUN docker-php-ext-install -j$(nproc) bcmath intl mcrypt opcache pdo_mysql soap xsl zip
RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd
RUN pecl install xdebug-2.5.5
RUN apt-get clean -qy
RUN rm -f /etc/nginx/sites-enabled/default
RUN ln -sf /dev/stdout /var/log/nginx/access.log
RUN ln -sf /dev/stderr /var/log/nginx/error.log
RUN rm -rf /var/lib/apt
RUN rm -rf /usr/src/php

# Install extra helper stuff
COPY src/wait-for-port /usr/local/bin/wait-for-port
RUN curl -sL https://getcomposer.org/download/1.5.2/composer.phar -o /usr/local/bin/composer
RUN chmod +x /usr/local/bin/composer
RUN curl -sL https://files.magerun.net/n98-magerun-1.100.0.phar -o /usr/local/bin/n98-magerun
RUN chmod +x /usr/local/bin/n98-magerun
RUN curl -sL https://github.com/wp-cli/wp-cli/releases/download/v1.3.0/wp-cli-1.3.0.phar -o /usr/local/bin/wp
RUN chmod +x /usr/local/bin/wp

# Install config files and tester site
COPY ./config/nginx /etc/nginx
COPY ./config/php /usr/local/etc/php
COPY ./config/supervisor/conf.d /etc/supervisor/conf.d
COPY ./tester /usr/share/nginx/tester

# nullmailer
RUN rm -f /var/spool/nullmailer/trigger \
  && mkfifo /var/spool/nullmailer/trigger \
  && chown mail:root /var/spool/nullmailer/trigger \
  && chmod 0622 /var/spool/nullmailer/trigger

# Set working directory
RUN chown -R www-data:www-data /var/www
WORKDIR /var/www

# Default command
CMD ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisor/supervisord.conf"]

# Expose ports
EXPOSE 80
