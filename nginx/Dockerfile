FROM debian:bookworm

RUN apt-get update && \
	apt-get install -y nginx

COPY nginx.conf /etc/nginx/nginx.conf

COPY html /var/www/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]