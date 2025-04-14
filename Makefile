THIS_FILE := $(lastword $(MAKEFILE_LIST))

.PHONY: help build up start down destroy stop restart logs logs-api ps login-timescale login-api db-shell

build:
	docker-compose -f ./docker-compose.yml build --no-cache $(c)
up: build
	docker-compose -f ./docker-compose.yml up -d $(c)
start:
	docker-compose -f ./docker-compose.yml start $(c)
down:
	docker-compose -f ./docker-compose.yml down $(c)
destroy:
	docker-compose -f ./docker-compose.yml down -v $(c)
stop:
	docker stop $$(docker ps -aq)
restart: stop up
logs:
	docker-compose -f ./docker-compose.yml logs -f $(c)
# logs-api:
# 	docker-compose -f ./docker-compose.yml logs -f api
ps:
	docker-compose -f ./docker-compose.yml ps

clean:
	@if [ -n "$$(docker ps -qa)" ]; then docker rm -f $$(docker ps -qa); fi
	@if [ -n "$$(docker images -qa)" ]; then docker rmi -f $$(docker images -qa); fi
	@if [ -n "$$(docker network ls -q | grep -vE 'bridge|host|none')" ]; then docker network rm -f $$(docker network ls -q | grep -vE 'bridge|host|none'); fi
	@if [ -n "$$(docker volume ls -q)" ]; then docker volume rm -f $$(docker volume ls -q); fi

fclean :
	docker system prune -a --force
	sudo rm -rf /var/data/*/*
