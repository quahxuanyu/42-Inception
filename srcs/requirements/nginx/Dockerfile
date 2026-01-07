FROM debian:bookworm

RUN apt-get update && apt-get install -y \
    nginx \
    openssl \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /etc/nginx/ssl

COPY conf/nginx.conf /etc/nginx/nginx.conf
COPY tools/setup_tls.sh /usr/local/bin/setup_tls.sh

RUN chmod +x /usr/local/bin/setup_tls.sh

EXPOSE 443

ENTRYPOINT ["setup_tls.sh"]
