WEBSERVER_SERVICE			:=	webserver
APPLICATION_SERVICE			:=	application

STACK_PROD					:= web
COMPOSE_PROD				:= ./.include/php/docker-compose.prod.yml
ENV_PROD					:= .env.prod

PHP_CONF_PATH				:= ./.include/php/configs

all: build up logs

build:
	@docker compose build --pull

up:
	@docker compose up -d --remove-orphans

up-f:
	@docker compose up -d --remove-orphans --force-recreate

logs:
	@docker compose logs -f -n 100

exec-nginx:
	@docker compose exec $(WEBSERVER_SERVICE) sh

exec-php:
	@docker compose exec $(APPLICATION_SERVICE) sh

down:
	@docker compose down

down-v:
	@docker compose down -v

deploy-prod:
	include $(ENV_PROD)
	docker stack deploy -c $(COMPOSE_PROD) $(STACK_PROD)

update-default-php-conf:
	for version in 5 7 8; do \
		docker run --rm --entrypoint=cat php:$$version-fpm-alpine /usr/local/etc/php/php.ini-development > $(PHP_CONF_PATH)/php-$$version-prod.default.ini; \
		docker run --rm --entrypoint=cat php:$$version-fpm-alpine /usr/local/etc/php/php.ini-development > $(PHP_CONF_PATH)/php-$$version-dev.default.ini; \
		docker run --rm --entrypoint=cat php:$$version-fpm-alpine /usr/local/etc/php-fpm.d/www.conf.default > $(PHP_CONF_PATH)/fpm-$$version-dev.default.ini; \
	done

.PHONY: logs
