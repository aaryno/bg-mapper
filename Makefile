
help: ## List the available targets
	@awk 'BEGIN {FS = ":.*?## "} /^[^: ]+:.*?## / {printf "\033[36m%-25s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

data_dir := $(shell pwd)/data
docker-prepare: ## Create data directories for 
	mkdir -p $(data_dir)/geoserver_data
	mkdir -p $(data_dir)/postgres_data
	mkdir -p $(data_dir)/web_data
	scripts/docker-setup.sh $(data_dir)
	