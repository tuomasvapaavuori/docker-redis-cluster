build:
	docker build -t redis-cluster .
rebuild:
	docker build --no-cache -t redis-cluster .
down:
	docker-compose down
up:
	make down
	make build
	docker-compose up -d
monitor:
	docker-compose logs
run-cli:
	docker-compose exec redis-cluster redis-cli -c -p $(REDIS_PORT)
run-shell:
	docker-compose exec redis-cluster /bin/bash
stop-swarm:
	docker stack rm redis-cluster
	docker swarm leave --force
start-swarm:
	make stop-swarm
	make build
	docker swarm init
	docker stack deploy -c docker-compose.yml redis-cluster
push:
	make build
	docker tag redis-cluster tuomasvapaavuori/redis-cluster:latest
	docker push tuomasvapaavuori/redis-cluster:latest