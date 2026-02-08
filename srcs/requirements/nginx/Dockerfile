FROM debian:bookworm

RUN apt-get update && \
	apt-get install -y \
	nginx \
	openssl

COPY ./conf/nginx.conf /etc/nginx/nginx.conf
COPY ./tools/setup.sh /tmp/setup.sh
RUN chmod +x /tmp/setup.sh

EXPOSE 443

ENTRYPOINT [ "/tmp/setup.sh" ]