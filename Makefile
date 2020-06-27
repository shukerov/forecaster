rebuild:
	docker-compose up --build

debug:
	docker-compose stop web
	docker-compose run --service-ports web

