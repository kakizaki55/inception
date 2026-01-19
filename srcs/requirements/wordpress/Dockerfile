FROM debian:bullseye

# installing php curl and mariadb client
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    php-fpm \
    php-mysql \
    php-curl \
    php-gd \
    php-mbstring \
    php-xml \
    php-zip \
    wget \
    curl \
    mariadb-client \
    && rm -rf /var/lib/apt/lists/*

# Download and install WP-CLI (pinned + checksum verified for reproducible builds)
ARG WP_CLI_VERSION=2.10.0
ARG WP_CLI_SHA256=6c6c4e5d3a3cf0d1f14e8c37bf7fd6d9e9e3c9e6d2c9c36e8c0bb3c4b9e4fdb1
RUN curl -fsSLo /usr/local/bin/wp "https://github.com/wp-cli/wp-cli/releases/download/v${WP_CLI_VERSION}/wp-cli-${WP_CLI_VERSION}.phar" \
    && echo "${WP_CLI_SHA256}  /usr/local/bin/wp" | sha256sum -c - \
    && chmod +x /usr/local/bin/wp

RUN mkdir -p /var/www/html /run/php

COPY tools/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

WORKDIR /var/www/html
EXPOSE 9000

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["php-fpm", "-F"]