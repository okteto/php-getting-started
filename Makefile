.PHONY: build
build:
	okteto build -t okteto/hello-world:php .

.PHONY: start
start:
	php -S 0.0.0.0:8080