FROM php:7.0.4-fpm
MAINTAINER Tom Richards <tom.r@delegator.com>

# Install packages
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update -q \
  && apt-get upgrade -qy \
  && apt-get install -qy \
    bash nginx-full supervisor \
    mysql-client redis-tools \
    build-essential curl htop git vim wget \
    npm nodejs nodejs-legacy ruby ruby-dev libmcrypt4 \
    libcurl4-openssl-dev libfreetype6-dev libjpeg62-turbo-dev libmcrypt-dev \
    libpng12-dev libxml2-dev zlib1g-dev \
  && apt-mark unmarkauto npm \
  && docker-php-ext-install bcmath curl dom hash iconv mcrypt opcache pdo pdo_mysql simplexml soap zip \
  && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
  && docker-php-ext-install gd \
  && apt-get clean -qy \
  && rm -f /etc/nginx/sites-enabled/default \
  && ln -sf /dev/stdout /var/log/nginx/access.log \
  && ln -sf /dev/stderr /var/log/nginx/error.log \
  && rm -rf /var/lib/apt \
  && rm -rf /usr/src/php

# Install extra helper stuff
RUN curl -sL https://getcomposer.org/download/1.0.0-beta1/composer.phar -o /usr/local/bin/composer \
    && chmod +x /usr/local/bin/composer \
    && curl -sL https://files.magerun.net/n98-magerun-1.97.14.phar -o /usr/local/bin/n98-magerun \
    && chmod +x /usr/local/bin/n98-magerun \
    && curl -sL https://github.com/wp-cli/wp-cli/releases/download/v0.22.0/wp-cli-0.22.0.phar -o /usr/local/bin/wp-cli \
    && chmod +x /usr/local/bin/wp-cli

# Install config files and tester site
COPY ./config/nginx /etc/nginx
COPY ./config/php /usr/local/etc/php
COPY ./config/supervisor/conf.d /etc/supervisor/conf.d
COPY ./tester /usr/share/nginx/tester

# Set working directory
RUN chown -R www-data:www-data /var/www
WORKDIR /var/www

# Default command
CMD ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisor/supervisord.conf"]

# Expose ports
EXPOSE 80
