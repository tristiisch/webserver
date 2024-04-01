WEBSERVER_SERVICE			:=	webserver
BACKEND_SERVICE				:=	backend
CERTIFICAT_PATH				:=	./.include/nginx/certificats/selfsigned.crt
CERTIFICAT_KEY_PATH			:=	./.include/nginx/certificats/selfsigned.key
CERTIFICAT_SUB				:=	"/C=FR/ST=IDF/L=Paris/O=42/OU=42/CN=127.0.0.1"

all: start-f logs

start:
	@docker compose up -d --remove-orphans

start-f:
	@docker compose up -d --remove-orphans --force-recreate

start-b:
	@docker compose up -d --remove-orphans --build

stop:
	@docker compose stop

down:
	@docker compose down

down-v:
	@docker compose down -v

config:
	@docker compose config

logs:
	@docker compose logs -f -n 100

exec-w:
	@docker compose exec $(WEBSERVER_SERVICE) sh

exec-b:
	@docker compose exec $(BACKEND_SERVICE) sh

# ECDSA certificat
update-certificat:
	openssl ecparam -genkey -name prime256v1 -out $(CERTIFICAT_KEY_PATH)
	openssl req -x509 -nodes -days 365 -key $(CERTIFICAT_KEY_PATH) -out $(CERTIFICAT_PATH) -sha256 -subj $(CERTIFICAT_SUB) -extensions v3_req
	docker compose cp $(CERTIFICAT_PATH) $(WEBSERVER_SERVICE):/etc/ssl/certs/
	docker compose cp $(CERTIFICAT_KEY_PATH) $(WEBSERVER_SERVICE):/etc/ssl/private/
	docker compose exec $(WEBSERVER_SERVICE) nginx -s reload

.PHONY: logs
