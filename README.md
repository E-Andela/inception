AI Prompts:

I want to create an Nginx server in a docker container. I want to start writing my own Dockerfile for this. Where do I begin?

When nginx is running in a container, where should the files be located that it hosts? How do you configure how it runs? Where is the config file?

I'm only allowed to use the second to last Debian or Alpine version.
Latest is trixie, second latest is Bookworm

Build with docker build -t my-nginx .

Then incorporate a wordpress website step by step.

Add a mariadb database.

Make all three work with docker compose

I have to setup a second container with wordpress and php.

References:
https://docker-curriculum.com/
https://docs.docker.com/