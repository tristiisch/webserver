ARG PHP_MAJOR="8"

# <=========================> APP production <=========================>
FROM ghcr.io/tristiisch/php-fpm:$PHP_MAJOR-production AS app_production

# SRCS
COPY --chown=root:app --chmod=550 ./srcs ./

# <=========================> APP development <=========================>
FROM ghcr.io/tristiisch/php-fpm:$PHP_MAJOR-development AS app_development

# SRCS
COPY --chown=root:app --chmod=550 ./srcs ./

# <=========================> Proxy <=========================>
FROM ghcr.io/tristiisch/nginx-php:latest AS proxy

COPY --chown=root:app --chmod=440 ./assets/img /var/www/html/img
COPY --chown=root:app --chmod=440 ./assets/logo /var/www/html/logo
