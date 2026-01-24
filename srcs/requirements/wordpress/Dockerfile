FROM debian:bullseye

# installing php curl and mariadb client
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    php7.4-fpm \
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
# ARG WP_CLI_VERSION=2.10.0
# ARG WP_CLI_SHA256=4c6a93cecae7f499ca481fa7a6d6d4299c8b93214e5e5308e26770dbfd3631df
RUN curl -fsSLo /usr/local/bin/wp "https://github.com/wp-cli/wp-cli/releases/download/v${WP_CLI_VERSION}/wp-cli-${WP_CLI_VERSION}.phar" \
    && echo "${WP_CLI_SHA256}  /usr/local/bin/wp" | sha256sum -c - \
    && chmod +x /usr/local/bin/wp

RUN mkdir -p /var/www/html /run/php

COPY tools/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

WORKDIR /var/www/html
EXPOSE 9000

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["php-fpm7.4", "-F"]