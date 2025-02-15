WEBSERVER_SERVICE			:=	webserver
APPLICATION_SERVICE			:=	application

CERTIFICAT_PATH				:=	./.include/nginx/certificats/selfsigned.crt
CERTIFICAT_KEY_PATH			:=	./.include/nginx/certificats/selfsigned.key
CERTIFICAT_SUB				:=	"/C=FR/ST=IDF/L=Paris/O=42/OU=42/CN=127.0.0.1"

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

# ECDSA certificat
update-certificat:
	openssl ecparam -genkey -name prime256v1 -out $(CERTIFICAT_KEY_PATH)
	openssl req -x509 -nodes -days 365 -key $(CERTIFICAT_KEY_PATH) -out $(CERTIFICAT_PATH) -sha256 -subj $(CERTIFICAT_SUB) -extensions v3_req
	docker compose cp $(CERTIFICAT_PATH) $(WEBSERVER_SERVICE):/etc/ssl/certs/
	docker compose cp $(CERTIFICAT_KEY_PATH) $(WEBSERVER_SERVICE):/etc/ssl/private/
	docker compose exec $(WEBSERVER_SERVICE) nginx -s reload

.PHONY: logs
