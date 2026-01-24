FROM debian:bullseye

# installing php curl and mariadb client
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    php7.4-fpm \
    php-mysql \
    php-mbstring \
    php-xml \
    curl \
    wget \
    php-curl \
    php-gd \
    php-zip \
    mariadb-client \
    && rm -rf /var/lib/apt/lists/*

# Download and install WP-CLI (pinned version for reproducible builds)
ARG WP_CLI_VERSION=2.10.0
RUN curl -fsSLo /usr/local/bin/wp "https://github.com/wp-cli/wp-cli/releases/download/v${WP_CLI_VERSION}/wp-cli-${WP_CLI_VERSION}.phar" \
    && chmod +x /usr/local/bin/wp

RUN mkdir -p /var/www/html /run/php

COPY tools/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

WORKDIR /var/www/html
EXPOSE 9000

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["php-fpm7.4", "-F"]