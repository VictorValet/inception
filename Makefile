all: volumes
	docker compose -f ./srcs/docker-compose.yml up -d --build

re: clean all

up : volumes
	docker compose -f ./srcs/docker-compose.yml up -d

down :
	docker compose -f ./srcs/docker-compose.yml down

start : 
	docker compose -f ./srcs/docker-compose.yml start

stop : 
	docker compose -f ./srcs/docker-compose.yml stop

cleanv:
	@ sudo rm -Rf ~/data

clean: down cleanv
	@docker rm $$(docker ps -qa) 2>/dev/null || true
	@docker rmi -f $$(docker images -qa) 2>/dev/null || true
	@docker volume rm $$(docker volume ls -q) 2>/dev/null || true
	@docker network rm $$(docker network ls -q) 2>/dev/null || true
	@docker system prune -af

volumes:
	@ mkdir -p /home/vvalet/data/wordpress
	@ mkdir -p /home/vvalet/data/mariadb

.PHONY: all re up down start stop clean cleanv volumes
