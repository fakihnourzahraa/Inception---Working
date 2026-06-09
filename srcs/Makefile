NAME = inception

all: up

up:
	sudo docker-compose -f docker-compose.yml up -d --build

down:
	sudo docker-compose -f docker-compose.yml down

stop:
	sudo docker-compose -f docker-compose.yml stop

start:
	sudo docker-compose -f docker-compose.yml start

restart: down up

clean: down
	sudo docker system prune -f

fclean: down
	sudo docker system prune -af
	sudo rm -rf /home/nfakih/data

re: fclean all

logs:
	sudo docker-compose -f docker-compose.yml logs -f

status:
	sudo docker-compose -f docker-compose.yml ps

.PHONY: all up down stop start restart clean fclean re logs status