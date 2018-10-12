FROM php:7.0.32-fpm
LABEL maintainer="Tom Richards <tom.r@delegator.com>"

# Pre-repository setup: Add support for HTTPS repositories, GPG keys
RUN apt-get update -q \
 && apt-get install -qy apt-transport-https gnupg

# Repository: Yarn package manager
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
COPY ./config/etc/apt/sources.list.d/yarn.list /etc/apt/sources.list.d/yarn.list

# Repository: Node.js 8
RUN curl --silent https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add -
COPY ./config/etc/apt/sources.list.d/nodesource.list /etc/apt/sources.list.d/nodesource.list

# Post-repository setup: update packages
RUN apt-get update -q \
 && apt-get upgrade -qy

# Install packages
RUN devDependencies="libcurl4-openssl-dev libfreetype6-dev libicu-dev libjpeg62-turbo-dev libmcrypt-dev libpng-dev libxml2-dev libxslt1-dev zlib1g-dev" \
 && DEBIAN_FRONTEND=noninteractive apt-get install -qy \
    bash supervisor \
    build-essential \
    curl htop git vim wget \
    nginx-light libnginx-mod-http-headers-more-filter \
    mysql-client redis-tools nullmailer \
    nodejs yarn \
    ruby ruby-dev rake \
    sassc \
    libmcrypt4 libxml2-utils \
    $devDependencies

# Add PHP stuff
RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
 && docker-php-ext-install -j$(nproc) bcmath gd intl mcrypt mysqli opcache pdo_mysql soap xsl zip \
 && pecl install xdebug-2.6.1

# Cleanup
RUN apt-get purge --auto-remove -qy $devDependencies \
 && rm -rf /var/lib/apt \
 && rm -rf /usr/src/php \
 && rm -f /etc/nginx/sites-enabled/default \
 && ln -sf /dev/stdout /var/log/nginx/access.log \
 && ln -sf /dev/stderr /var/log/nginx/error.log

# Install extra helper stuff
COPY src/wait-for-port /usr/local/bin/wait-for-port
RUN curl -sL https://getcomposer.org/download/1.1.2/composer.phar -o /usr/local/bin/composer
RUN chmod +x /usr/local/bin/composer
RUN curl -sL https://files.magerun.net/n98-magerun-1.102.0.phar -o /usr/local/bin/n98-magerun
RUN chmod +x /usr/local/bin/n98-magerun

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
