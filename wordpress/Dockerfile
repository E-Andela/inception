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

WORKDIR /var/www/html

CMD ["php-fpm8.2", "-F"]