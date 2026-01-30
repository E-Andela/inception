FROM debian:bookworm

RUN apt-get update && \
	apt-get install -y \
	php-fpm \
	php-mysql \
	php-cli \
	php-curl \
	php-gd \
	php-mbstring \
	php-xml \
	php-zip \
	php-intl \
	wget \
	unzip 

RUN sed -i 's|^listen = .*|listen = 0.0.0.0:9000|' /etc/php/8.2/fpm/pool.d/www.conf
RUN mkdir -p /var/www/html

WORKDIR /var/www/html
COPY ./setup.sh /tmp/setup.sh
RUN chmod +x /tmp/setup.sh

ENTRYPOINT [ "/tmp/setup.sh" ]