FROM debian:bookworm

RUN apt-get update && \
	apt-get install -y \
	nginx \
	openssl

COPY ./conf/nginx.conf /etc/nginx/nginx.conf
COPY ./tools/setup.sh /tmp/setup.sh
RUN chmod +x /tmp/setup.sh

# COPY html /var/www/html

EXPOSE 80

ENTRYPOINT [ "/tmp/setup.sh" ]