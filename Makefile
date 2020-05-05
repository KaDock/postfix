build:
	sudo docker build -t kalledk/postfix Docker

enter:
	sudo docker-compose run --rm postfix /bin/sh

down:
	sudo docker-compose down

up:
	sudo docker-compose up -d


dump:
	sudo docker-compose run --rm postfix /dump.sh | sudo tee dump.ini

load:
	sudo docker-compose run --rm postfix /load.sh < dump.ini
