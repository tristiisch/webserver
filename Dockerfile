# <=========================> PHP <=========================>
FROM php:8-fpm-alpine as backend
ARG USER="www-data"

WORKDIR /var/www/html

COPY --chown=root:$USER --chmod=550  ./srcs ./

USER $USER

EXPOSE 9000

CMD ["php-fpm"]

# <========================> NGinX <========================>
FROM nginx:stable-alpine as webserver
ARG USER="nginx"

# Cache
RUN mkdir -p /var/cache/nginx \
	&& chown root:$USER -R /var/cache/nginx \
	&& chmod 770 -R /var/cache/nginx

# Config
COPY ./.include/nginx/nginx.conf /etc/nginx/nginx.conf

# Certificats
COPY ./.include/nginx/certificats/selfsigned.crt /etc/ssl/certs/
COPY ./.include/nginx/certificats/selfsigned.key /etc/ssl/private/

WORKDIR /var/www

# Errors pages
RUN mkdir -p ./errors \
	&& chown root:$USER -R ./errors \
	&& chmod 550 -R ./errors \
	&& mkdir -p ./html/errors \
	&& chown root:$USER -R ./html/errors\
	&& chmod 550 -R ./html/errors
COPY --chown=root:$USER --chmod=550 ./.include/nginx/errors/*.html ./errors
COPY --chown=root:$USER --chmod=550 ./.include/nginx/errors/*.css ./html/errors

# Assets
COPY --chown=root:$USER --chmod=550 ./assets ./html/assets

HEALTHCHECK --interval=10s --timeout=3s --retries=3 \
  CMD curl -f http://localhost/nginx_status || exit 1

# USER $USER

# CMD ["nginx", "-g", "daemon off"]
