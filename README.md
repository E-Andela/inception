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

29/01/2026
to run mariadb we do:
docker run -it --network webnet --name mariadb -v dbdata mariadb bash

30/01/2026
added setup.sh to wordpress. Gives ownership to www-data of /var/www/html so we can make wp-config.php
How do we login via a script?
And what is this second user?
What is the admin account and what privileges does the other account need?
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar

02/02/2026
figure out the steps to install wp-cli
curl the url -> give execution rights -> move somewhere accesible for $PATH -> download wp files with: wp core download. Don't do this in the dockerfile but in the entrypoint script. Otherwise the volume will overwrite it.

How to get env variables in my container? put env_file: in container.
For tomorrow:
Fix connection issue? Just changed nginx.conf

03/02/2026
Add ssl certificates??
Put passwords in secrets.
How to change the domain name?
Why do we get to store the passwords in .txt files??
How do I get my containers to restart in case of crash?

How to add ssl certificate:
add "listen 8443 ssl;" directive to config file.
add "ssl_certificate ...;" & "ssl_certificate_key ...;" locations
add "ssl_protocols TLSv1.3;"
continue with this tomorrow

04/02/2026
Install openssl
figure out how to do the url. Need to edit /etc/hosts
Add passwords to secrets.

Get containers to restart in case of crash. Got iiiiiiit.
for tomorrow: add secrets to script.

To change between localhost and eandela.42.fr
nginx.conf
listen 80; --> listen 433 ssl;
server_name eandela.42.fr;
ssl_certificate     /etc/nginx/ssl/nginx.crt;
ssl_certificate_key /etc/nginx/ssl/nginx.key;
ssl_protocols       TLSv1.2 TLSv1.3;

wordpress/setup.sh
--url="http://localhost:8080" --> --url="https://eandela.42.fr"

docker-compose.yml
ports: "8080:80" --> "443:443"

Changed the place the volumes are at, but not quite sure if it is the right way to go about it.
I created /etc/docker/daemon.json
{
  "data-root": "/home/eandela/data"
}

08/02/2026
fix folder structure			[x]
Image names -- remove :local	[x]
use bookworm or oldstable?		[x]
remove secrets from logs		[x]
get domain name from env		[x]
fix expose mismatch				[x]
create documentation			[]
add makefile					[x]
What the hell is dockerignore?	[x]
Fix mariadb login password.		[x]
rm daemon.json					[]
fix setup.sh mariadb			[]

for tomorrow
setup.sh can't run a second time because im not login in with root



References:
https://docker-curriculum.com/
https://docs.docker.com/