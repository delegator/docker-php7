.PHONY: all force help test stamp

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

build: stamp ## Build the docker image
	docker build -t delegator/php7 .

build-force: stamp ## Build the docker image, ignoring any existing layer cache
	docker build --no-cache=true -t delegator/php7 .

stamp: ## Update the "image built at" timestamp
	date -Ru >build-stamp

test: ## Run the docker image locally for testing
	docker run --rm -p 3000:80 delegator/php7
