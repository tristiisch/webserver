WEBSERVER_SERVICE			:=	webserver
APPLICATION_SERVICE			:=	application

STACK_PROD					:= web
COMPOSE_PROD				:= ./.docker/docker-compose.prod.yml
ENV_PROD					:= .env.prod

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

.PHONY: logs
