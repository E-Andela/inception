FROM debian:bookworm

RUN apt-get update && \
	apt-get install -y \
	nginx \
	openssl

COPY nginx.conf /etc/nginx/nginx.conf
COPY ./setup.sh /tmp/setup.sh
RUN chmod +x /tmp/setup.sh

# COPY html /var/www/html

EXPOSE 443

ENTRYPOINT [ "/tmp/setup.sh" ]