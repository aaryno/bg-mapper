
help: ## List the available targets
	@awk 'BEGIN {FS = ":.*?## "} /^[^: ]+:.*?## / {printf "\033[36m%-25s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

data_dir := $(shell pwd)/data
docker-prepare: ## Create data directories
	# mkdir -p $(data_dir)/geoserver_data 
	mkdir -p $(data_dir)/postgres_data
	mkdir -p $(data_dir)/web_data
	scripts/docker-setup.sh $(data_dir)

prepare: ## Install python libraries
	cd src && pip install -r requirements.txt

dev-up: ## Start up web app running on port 8000
	docker compose up -d
	sleep 2
	cd src && uvicorn main:app --reload

docker-build: ## prep geoserver (obsolete?)
	docker build . -t geoserver-init 