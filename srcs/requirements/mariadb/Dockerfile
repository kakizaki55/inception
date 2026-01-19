FROM debian:bullseye

# Bootstrap CA certificates: minimal base images may not have any trusted roots yet,
# so HTTPS APT endpoints fail with "Certificate verification failed".
# Install ca-certificates via HTTP first, then switch sources to HTTPS.
RUN sed -i 's|https://deb.debian.org|http://deb.debian.org|g' /etc/apt/sources.list \
 && sed -i 's|https://security.debian.org|http://security.debian.org|g' /etc/apt/sources.list \
 && apt-get update \
 && apt-get install -y --no-install-recommends ca-certificates debian-archive-keyring \
 && rm -rf /var/lib/apt/lists/* \
 && sed -i 's|http://deb.debian.org|https://deb.debian.org|g' /etc/apt/sources.list \
 && sed -i 's|http://security.debian.org|https://security.debian.org|g' /etc/apt/sources.list

RUN apt-get update && apt-get install -y --no-install-recommends \
    mariadb-server \
    mariadb-client \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /run/mysqld && chown -R mysql:mysql /run/mysqld

COPY tools/entrypoint.sh /usr/local/bin/entrypoint.sh

RUN chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 3306

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["mysqld", "--user=mysql", "--bind-address=0.0.0.0"]
