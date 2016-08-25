all: build

build:
	@docker build --tag=lurcio/apt-cacher-ng .
