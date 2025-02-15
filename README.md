# Dockerized Webserver with NginX, FastCGI, and PHP-FPM

This repository serves as a template for PHP projects within a Docker environment. It includes an advanced configuration for NginX, a production-ready PHP image, and a development image with XDebug integrated. The primary goal is to facilitate testing project clustering by running multiple PHP instances with a single NginX instance.

The Dockerfiles adhere to security best practices, ensuring:
- Applications are launched by a non-root user.
- This user has no write permissions on pre-existing files.

## Load Balancing
The setup employs a round-robin configuration where NginX evenly distributes requests to each PHP instance. For example, with 5 requests and 3 PHP instances:
1. Sent to PHP instance 1
2. Sent to PHP instance 2
3. Sent to PHP instance 3
4. Sent to PHP instance 1
5. Sent to PHP instance 2
and so forth...

This straightforward approach effectively distributes the workload across multiple instances in any Docker environment. NginX handles load balancing; the load balancing feature of NginX is not utilized here.

## NginX
NginX is configured for HTTP. Popular error pages have been customized. A health check, utilized by Docker, is set to the URL /status_nginx. HTTP requests are temporarily redirected, preventing automatic redirection caching on the client's browser.

## PHP
Based on PHP 8, the `PHP_MAJOR` argument allows choosing between versions 5, 7, and 8. In development mode, the image includes the XDebug tool (https://xdebug.org/). In production mode, the image utilizes recommended production parameters by PHP.

PHP-FPM logs are configured for use behind a reverse proxy (such as NginX).

## GitHub Package
This project generates a PHP image (`ghcr.io/tristiisch/php`): https://github.com/tristiisch/webserver/pkgs/container/php. You can simply use it in your Dockerfiles and add your sources to the current directory like so:
```
COPY --chown=root:1000 --chmod=550 ./srcs ./
```
Everything else is configured to work with FastCGI using the default port: 9000.

The following tags are available:
`latest`, `8`, `8-production`, `7`, `7-production`, `5`, `5-production`
`development`, `8-development`, `7-development`, `5-development`

Refer to the files in `.include/php`, `docker-compose.base.yml`, `docker-compose.yml`, and `Dockerfile` for insights into creating and utilizing these images.
