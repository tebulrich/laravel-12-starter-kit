FROM php:8.4-apache

ARG DOCKER_WWWGROUP
ARG DOCKER_WWWUSER
ARG NODE_VERSION=20

WORKDIR /var/www/html

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=UTC

# Set timezone
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Update and install essential packages
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

# Download and install the latest FrankenPHP based on FAP_ARCHITECTURE
RUN latest_version=$(curl -s https://api.github.com/repos/dunglas/frankenphp/releases/latest | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/') && \
    wget -O /tmp/frankenphp-linux-x86_64 https://github.com/dunglas/frankenphp/releases/download/${latest_version}/frankenphp-linux-x86_64 && \
    mv /tmp/frankenphp-linux-x86_64 /usr/local/bin/frankenphp && \
    chmod +x /usr/local/bin/frankenphp

# Create FrankenPHP Apache configuration file
RUN echo '<IfModule mod_proxy.c>\n\
    ProxyPassMatch ^/(.*\.php(/.*)?)$ unix:/run/php/php8.4-fpm.sock|fcgi://localhost/var/www/html/\n\
</IfModule>' > /etc/apache2/conf-available/frankenphp.conf

# Enable Apache modules
RUN a2enmod rewrite headers

# Install Node.js and Yarn
RUN curl -sL https://deb.nodesource.com/setup_$NODE_VERSION.x | bash - && \
    apt-get install -y --no-install-recommends nodejs && \
    npm install --global yarn && \
    rm -rf /var/lib/apt/lists/*

RUN pecl install xdebug

# Install PHP extensions
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

RUN docker-php-ext-enable xdebug

# Clean up the image
RUN apt-get clean && apt-get autoremove -y

# Enable Apache modules
RUN a2enmod rewrite headers

# Get latest Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
COPY php.ini /usr/local/etc/php/php.ini

# Create user and group
RUN groupadd --gid 1000 $DOCKER_WWWGROUP && \
    useradd --uid 1000 --gid 1000 -m $DOCKER_WWWUSER && \
    chown 1000:1000 /var/log -R && chown 1000:1000 /var/run/ -R

# Switch to the new user
USER $DOCKER_WWWUSER

# Set the command to run the supervisor
CMD ["/usr/bin/supervisord"]
