ARG PHP_MAJOR="8"
ARG USER="app"
ARG USER_ID="1000"
ARG GROUP="app"
ARG GROUP_ID="1000"

# <=========================> PHP base <=========================>
FROM php:$PHP_MAJOR-fpm-alpine AS base
ARG PHP_MAJOR
ARG USER
ARG USER_ID
ARG GROUP
ARG USER_ID
ARG GROUP_ID
EXPOSE 9000/tcp

# Health Check
RUN apk add --upgrade --no-cache fcgi
COPY ./.include/php/scripts/healthcheck.sh /usr/local/bin/php-fpm-healthcheck
RUN chmod +x /usr/local/bin/php-fpm-healthcheck
HEALTHCHECK --interval=10s --timeout=3s --retries=3 \
    CMD php-fpm-healthcheck || exit 1

RUN addgroup -g $GROUP_ID $GROUP && \
    adduser -D -G $USER -u $USER_ID -s /sbin/nologin app

# FPM config
COPY --chown=root:$USER --chmod=550 ./.include/php/configs/fpm-${PHP_MAJOR}.ini /usr/local/etc/php-fpm.d/zm-custom.conf

# User & Workdir
USER $USER
WORKDIR /var/www/html

# Validate FPM configuration
RUN php-fpm -t

# Command at startup
CMD ["php-fpm"]

# <=========================> Base production <=========================>
FROM base AS base_production

# PHP config production
RUN cp -f /usr/local/etc/php/php.ini-production /usr/local/etc/php/php.ini

# PHP custom production config
COPY --chown=root:$USER --chmod=440 ./.include/php/configs/php-prod.ini /usr/local/etc/php/conf.d/zm-php.ini

# SRCS
COPY --chown=root:$USER --chmod=550 ./srcs ./

# <=========================> APP production <=========================>
FROM base_production AS app_production

# SRCS
COPY --chown=root:$USER --chmod=550 ./srcs ./

# <=========================> PHP development <=========================>
FROM base AS base_development
ARG USER

# Debug Tools
USER root
ENV XDEBUG_TRIGGER "yes"
RUN apk add --virtual xdebug-deps --upgrade --no-cache autoconf g++ make linux-headers \
	&& pecl channel-update pecl.php.net \
	&& case "$PHP_VERSION" in \
		"4.4"*) \
			pecl install xdebug-2.0.2 \
			;; \
		"5.0"*) \
			pecl install xdebug-2.0.5 \
			;; \
		"5.1"*|"5.2"*|"5.3"*) \
			pecl install xdebug-2.2.7 \
			;; \
		"5.4"*) \
			pecl install xdebug-2.4.1 \
			;; \
		"5.5"*|"5.6"*) \
			pecl install xdebug-2.5.5 \
			;; \
		"7.0"*|"7.1"*) \
			pecl install xdebug-2.9.8 \
			;; \
		"7.2"*|"7.3"*|"7.4"*) \
			pecl install xdebug-3.1.6 \
			;; \
		*) \
			pecl install xdebug \
			;; \
	esac \
	&& docker-php-ext-enable xdebug \
	&& apk del xdebug-deps \
	&& case "$PHP_VERSION" in \
		"4"*|"5"*|"7.0"*|"7.1"*) \
			{ \
				echo "xdebug.remote_host=host.docker.internal"; \
				echo "xdebug.remote_port=9003"; \
				echo "xdebug.remote_autostart=1"; \
				echo "xdebug.remote_enable=0"; \
				echo "xdebug.default_enable=0"; \
				echo "xdebug.profiler_enable=0"; \
				echo "xdebug.auto_trace=0"; \
				echo "xdebug.coverage_enable=0"; \
				echo "xdebug.remote_log=/var/log/php/xdebug.log"; \
				echo "xdebug.output_dir=/opt/debug_profiler"; \
			} >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
			;; \
		*) \
			{ \
				echo "xdebug.client_host=host.docker.internal"; \
				echo "xdebug.output_dir=/opt/debug_profiler"; \
				echo "xdebug.log=/var/log/php/xdebug.log"; \
			} >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
			;; \
	esac \
	&& mkdir -p /opt/debug_profiler && mkdir -p /var/log/php \
	&& chmod 755 -R /opt/debug_profiler && chmod 755 -R /var/log/php \
	&& chown -R $USER:$USER /opt/debug_profiler && chown -R $USER:$USER /var/log/php
USER $USER

# PHP config development
USER root
RUN cp -f /usr/local/etc/php/php.ini-development /usr/local/etc/php/php.ini
USER $USER

# PHP custom dev config
COPY --chown=root:$USER --chmod=440 ./.include/php/configs/php-dev.ini /usr/local/etc/php/conf.d/zm-php.ini

# SRCS
COPY --chown=root:$USER --chmod=550 ./srcs ./

# <=========================> APP development <=========================>
FROM base_development AS app_development

# SRCS
COPY --chown=root:$USER --chmod=550 ./srcs ./
