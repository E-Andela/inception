AI Prompts:

I want to create an Nginx server in a docker container. I want to start writing my own Dockerfile for this. Where do I begin?

When nginx is running in a container, where should the files be located that it hosts? How do you configure how it runs? Where is the config file?

I'm only allowed to use the second to last Debian or Alpine version.
Latest is trixie, second latest is Bookworm

Build with docker build -t my-nginx .

Then incorporate a wordpress website step by step.

Add a mariadb database.

Make all three work with docker compose

I have to setup a second container with wordpress and php. Wordpress contents goes in a volume on the host machine. PHP is installed in the container.

I want to create a volume where my website hosted by my nginx server is stored. Without yet thinking about making another container with php and wordpress.

How do I get the files from my host machine to the volume?
$: docker volume create webdata
$: docker run -d -v webdata:/var/www/html -p 8080:80 --name nginx-vol my-nginx
then copy files to /var/www/html and it is saved to the volume

23/01/2026
Get nginx and wordpress containers working together over a network.
How does nginx get php requests to the php server?
How do I set the php server to listen to port 9000?
listen = /run/php/php8.2-fpm.sock	====> listen = 0.0.0.0:9000 in /etc/php/8.2/fpm/pool.d/www.conf
How do you set up a docker network?
docker create network <network name>
How do you assign a network to a docker container?
when creating a container add: --network <network name>

24/01/2026
Edit the php config file:
listen = /run/php/php8.2-fpm.sock	====> listen = 0.0.0.0:9000
docker create network webnet
docker run -d -v webdata:/var/www/html --name wordpress --network webnet wordpress
docker run -d -v webdata:/var/www/html --name nginx --network webnet -p 8080:80 nginx

Get wordpress content in there.

26/01/2026
create compose file
set up database.
How do I properly configure mariadb?

27/01/2026
 $ docker run -it --network webnet --name mariadb -v my_git_dbdata mariadb bash
service mariadb start

References:
https://docker-curriculum.com/
https://docs.docker.com/