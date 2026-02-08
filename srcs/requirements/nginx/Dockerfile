FROM debian:bookworm

RUN apt-get update && \
	apt-get install -y \
	nginx \
	openssl

COPY ./conf/nginx.conf.template /etc/nginx/nginx.conf.template
COPY ./tools/setup.sh /tmp/setup.sh
RUN chmod +x /tmp/setup.sh

EXPOSE 443

ENTRYPOINT [ "/tmp/setup.sh" ]