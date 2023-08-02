
check-configure:
	@if [ -z "$$(grep -w "MYSQL_PASSWORD" .env | cut -d'=' -f2- | sed 's/"//g' | sed 's/#.*//'| sed 's/ //g')" ]; then \
		echo "Error: MYSQL_PASSWORD is not set in .env file."; \
		exit 1; \
	elif [ $$(grep -w "MYSQL_PASSWORD" .env | cut -d'=' -f2- | sed 's/"//g' | sed 's/#.*//' | wc -c) -lt 7 ]; then \
		echo "Error: MYSQL_PASSWORD must be at least 6 characters long." >&2; \
		exit 1; \
	fi
	@echo "check configure success"

init: 
	docker-compose pull

install: check-configure
	docker-compose up -d
	docker-compose ps

status:
	docker-compose ps

log:
	docker-compose logs -f $(filter-out $@,$(MAKECMDGOALS))

down:
	docker-compose down

purge: down
	@rm -rf $$(source .env && echo $$MYSQL_DATA_PATH)
	@rm -rf $$(source .env && echo $$KETADB_DATA_PATH)