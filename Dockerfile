# <=========================> PHP prod <=========================>
FROM php:8-fpm-alpine as application_production
ARG USER="www-data"

# Health Check
RUN apk add --no-cache fcgi \
	&& rm -rf /var/cache/apk/*
COPY ./.include/php/healthcheck.sh /usr/local/bin/php-fpm-healthcheck
RUN chmod +x /usr/local/bin/php-fpm-healthcheck
HEALTHCHECK --interval=10s --timeout=3s --retries=3 \
    CMD php-fpm-healthcheck || exit 1
ENV FCGI_STATUS_PATH="/status_php_fpm"

COPY ./.include/php/fpm.conf /usr/local/etc/php-fpm.d/www.conf
COPY ./.include/php/php-prod.ini /usr/local/etc/php/conf.d/01-php-prod.ini

WORKDIR /var/www/html

COPY --chown=root:$USER --chmod=550  ./srcs ./

USER $USER

EXPOSE 9000

# Validate configuration
RUN php-fpm -tt

CMD ["php-fpm"]

# <=========================> PHP dev <=========================>
FROM application_production as application_development

COPY ./.include/php/php-dev.ini /usr/local/etc/php/conf.d/02-php-dev.ini

# Validate configuration
RUN php-fpm -tt

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
  CMD curl --fail --location --insecure http://localhost/status_nginx || exit 1

# Validate configuration
RUN nginx -t

# USER $USER

# CMD ["nginx", "-g", "daemon off"]
