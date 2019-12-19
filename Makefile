.PHONY: build
build:
	okteto build -t okteto/hello-world:php .

.PHONY: push
push:
	php -S 0.0.0.0:8080