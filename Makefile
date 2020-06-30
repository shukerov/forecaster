rebuild:
	docker-compose up --build

js_install:
	docker-compose run --rm web yarn install && bundle exec rails webpacker:compile

console:
	docker-compose run --rm web bundle exec rails console

run_test:
	docker-compose run --rm web bundle exec rake test

debug:
	docker-compose stop web
	docker-compose run --service-ports web

