FROM php:7.0.8-fpm
MAINTAINER Tom Richards <tom.r@delegator.com>

# Install packages
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update -q
RUN apt-get upgrade -qy
RUN apt-get install -qy \
    bash nginx-full supervisor \
    mysql-client redis-tools nullmailer \
    build-essential hardening-wrapper \
    curl htop git vim wget \
    npm nodejs nodejs-legacy ruby ruby-dev libmcrypt4 libxml2-utils \
    libcurl4-openssl-dev libfreetype6-dev libjpeg62-turbo-dev libmcrypt-dev \
    libpng12-dev libxml2-dev zlib1g-dev
RUN apt-mark unmarkauto npm
RUN docker-php-ext-install bcmath mcrypt opcache pdo_mysql soap zip
RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/
RUN docker-php-ext-install gd
RUN apt-get clean -qy
RUN rm -f /etc/nginx/sites-enabled/default
RUN ln -sf /dev/stdout /var/log/nginx/access.log
RUN ln -sf /dev/stderr /var/log/nginx/error.log
RUN rm -rf /var/lib/apt
RUN rm -rf /usr/src/php

# Install extra helper stuff
RUN curl -sL https://getcomposer.org/download/1.2.0/composer.phar -o /usr/local/bin/composer
RUN chmod +x /usr/local/bin/composer
RUN curl -sL https://files.magerun.net/n98-magerun-1.97.22.phar -o /usr/local/bin/n98-magerun
RUN chmod +x /usr/local/bin/n98-magerun
RUN curl -sL https://github.com/wp-cli/wp-cli/releases/download/v0.23.1/wp-cli-0.23.1.phar -o /usr/local/bin/wp-cli
RUN chmod +x /usr/local/bin/wp-cli

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
