# PHP 8.4 + Apache image tailored for Laravel
# - Installs common build/runtime tools
# - Sets up Node.js and Yarn for asset building
# - Installs PHP extensions commonly needed by Laravel
# - Adds Composer and a basic php.ini
# - Downloads FrankenPHP binary and writes a simple Apache proxy config
# - Creates a non-root user similar to Laravel Sail
# - Uses supervisord as the default process

FROM php:8.4-apache

# IDs for the app user/group inside the container (match host for volume perms)
ARG DOCKER_WWWGROUP
ARG DOCKER_WWWUSER

# Node major version to install (via NodeSource)
ARG NODE_VERSION=20

# Application workdir
WORKDIR /var/www/html

# Keep apt noninteractive and set default timezone (can be overridden at build)
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=UTC

# FrankenPHP release to fetch
ENV FRANKENPHP_VERSION=v1.9.0
ENV FRANKENPHP_FILENAME=frankenphp-linux-x86_64

# Configure container timezone
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# System packages needed for PHP extensions, building tools, and supervision
RUN apt-get -y update --fix-missing && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
        apt-utils \
        apt-transport-https \
        curl \
        wget \
        nano \
        dialog \
        build-essential \
        git \
        gnupg2 \
        iputils-ping \
        libonig-dev \
        libsqlite3-dev \
        libsqlite3-0 \
        libpq-dev \
        htop \
        libzip-dev \
        libicu-dev \
        libxml2-dev \
        libxslt-dev \
        libssh2-1-dev \
        libssh2-1 \
        libcurl4-openssl-dev \
        pkg-config \
        openssl \
        zip \
        unzip \
        htop \
        logrotate \
        supervisor && \
    rm -rf /var/lib/apt/lists/*

# Download a static FrankenPHP binary
RUN echo "==> Downloading FrankenPHP $FRANKENPHP_VERSION ($FRANKENPHP_FILENAME)" && \
    curl -fL "https://github.com/php/frankenphp/releases/download/${FRANKENPHP_VERSION}/${FRANKENPHP_FILENAME}" -o /tmp/frankenphp && \
    chmod +x /tmp/frankenphp && \
    mv /tmp/frankenphp /usr/local/bin/frankenphp

# Minimal Apache conf to proxy PHP files to php-fpm socket
RUN echo '<IfModule mod_proxy.c>\n\
    ProxyPassMatch ^/(.*\.php(/.*)?)$ unix:/run/php/php8.4-fpm.sock|fcgi://localhost/var/www/html/\n\
</IfModule>' > /etc/apache2/conf-available/frankenphp.conf

# Install Node.js and Yarn for building frontend assets
RUN curl -sL https://deb.nodesource.com/setup_$NODE_VERSION.x | bash - && \
    apt-get install -y --no-install-recommends nodejs && \
    npm install --global yarn && \
    rm -rf /var/lib/apt/lists/*

# Xdebug via PECL (enabled by default; tune in php.ini if needed)
RUN pecl install xdebug && docker-php-ext-enable xdebug

# Core PHP extensions frequently needed by Laravel and tooling
RUN docker-php-ext-install \
    pdo_mysql \
    curl \
    zip \
    pdo_pgsql \
    pgsql \
    intl \
    mbstring \
    gettext \
    calendar \
    exif \
    pcntl \
    dom \
    xsl \
    simplexml \
    bcmath \
    sockets

# Trim down image a bit
RUN apt-get clean && apt-get autoremove -y

# Ensure Apache modules are enabled
RUN a2enmod rewrite headers

# Composer binary and project php.ini
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
COPY php.ini /usr/local/etc/php/php.ini

# Logrotate expects this directory to exist with proper perms
RUN mkdir -p /var/lib/logrotate && chmod 755 /var/lib/logrotate

# Copy project files and set ownership to the app user
COPY --chown=${DOCKER_WWWUSER}:${DOCKER_WWWGROUP} . /var/www/html

# Create a non-root user/group similar to Laravel Sail and fix perms
RUN groupadd --force -g $DOCKER_WWWGROUP sail \
 && useradd -ms /bin/bash --no-user-group -u $DOCKER_WWWUSER -g $DOCKER_WWWGROUP sail \
 && chown -R $DOCKER_WWWUSER:$DOCKER_WWWGROUP /var/log /var/run /var/lib/logrotate

# Run the container as the app user
USER $DOCKER_WWWUSER

# Default process: supervisord reads configs from /etc/supervisor/
CMD ["/usr/bin/supervisord"]
