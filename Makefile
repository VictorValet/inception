all: volumes
	docker compose -f ~/inception/srcs/docker-compose.yml up -d --build

re: fclean all

down:
	docker compose -f ~/inception/srcs/docker-compose.yml down

clean: down ## Stop Inception & Clean inception docker (prune -f)
	@ docker system prune -f

cleanv: ## Remove persistant datas
	@ sudo rm -rf ~/data

prune: down ## Remove all dockers on this system (prune -a)
	@ docker system prune -a

fclean: down prune cleanv ## Remove all dockers on this system & Remove persistant datas
	@echo "Stopping and removing containers..."
	@docker stop $$(docker ps -qa) 2>/dev/null || true
	@docker rm $$(docker ps -qa) 2>/dev/null || true
	@echo "Removing images..."
	@docker rmi -f $$(docker images -qa) 2>/dev/null || true
	@echo "Removing volumes..."
	@docker volume rm $$(docker volume ls -q) 2>/dev/null || true
	@echo "Removing networks..."
	@docker network rm $$(docker network ls -q) 2>/dev/null || true

volumes:
	@ mkdir -p /home/vvalet/data/wordpress
	@ mkdir -p /home/vvalet/data/mariadb

.PHONY: all re down clean
