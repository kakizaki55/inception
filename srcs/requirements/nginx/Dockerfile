FROM debian:bullseye

# installing nginx and openssl (keep image small for VMs)
RUN apt-get update \
    && apt-get install -y --no-install-recommends nginx openssl ca-certificates \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /etc/nginx/ssl /run/nginx

RUN openssl req -newkey rsa:4096 -x509 -sha256 -days 365 -nodes \
       -out /etc/nginx/ssl/mkakizak.crt \
       -keyout /etc/nginx/ssl/mkakizak.key \
       -subj "/C=JP/ST=Tokyo/L=Tokyo/O=school 42/OU=mkakizak/CN=mkakizak/"

# copying config file to /etc/...
COPY ./conf/nginx.conf /etc/nginx/conf.d/site.conf

# the only port allowed
EXPOSE 443

# Start nginx
CMD ["nginx", "-g", "daemon off;"]

