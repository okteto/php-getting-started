.PHONY: push
push:
	okteto build -t okteto/hello-world:php-dev --target dev .
	okteto build -t okteto/hello-world:php .
