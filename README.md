# Getting Started on Okteto with PHP

This example shows how to leverage [Okteto](https://github.com/okteto/okteto) to develop a PHP Sample App directly in Kubernetes. 

Okteto is a client-side only tool that works in any Kubernetes cluster. If you need access to a Kubernetes cluster, [Okteto Cloud](https://cloud.okteto.com) gives you free access to sandboxes Kubernetes namespaces, compatible with any Kubernetes tool.

## Step 1: Deploy the PHP Sample App

Get a local version of the PHP Sample App by executing the following commands:

```console
$ git clone https://github.com/okteto/php-getting-started
$ cd php-getting-started
```

The `k8s.yml` file contains the raw Kubernetes manifests to deploy the PHP Sample App. Run the application by executing:

> If you don't have `kubectl` installed, follow this [guide](https://kubernetes.io/docs/tasks/tools/install-kubectl/).

```console
$ kubectl apply -f k8s.yml
```

```console
deployment.apps "hello-world" created
service "hello-world" created
```

This is cool! You typed one command and a dev version of your application just runs 😎. 

## Step 2: Start your development environment in Kubernetes

With the PHP Sample Application deployed, run the following command:

```console
$ okteto up
 ✓  Development environment activated
 ✓  Files synchronized
    Namespace: default
    Name:      hello-world
    Forward:   8080 -> 8080
               58536 -> 22
    Reverse:   9000 <- 9000
               

Welcome to your development environment. Happy coding!
okteto>
```

The `okteto up` command starts a [Kubernetes development environment](https://okteto.com/docs/reference/development-environment/index.html), which means:

- The PHP Sample App container is updated with the docker image `okteto/php:7`. This image contains the required dev tools to build, test and run the PHP Sample App.
- A [file synchronization service](https://okteto.com/docs/reference/file-synchronization/index.html) is created to keep your changes up-to-date between your local filesystem and your application pods.
- A volume is attached to persist the Go cache and packages in your Kubernetes development environment.
- Container ports 8080 (the application) is forwarded to localhost.
- Container ports 9000 (the debugger) is reverse forwarded from the development environment to localhost.
- A remote shell is started in your Kubernetes development environment. Build, test and run your application as if you were in your local machine.

> All of this (and more) can be customized via the `okteto.yml` [manifest file](https://okteto.com/docs/reference/manifest/index.html). You can also use the file `.stignore` to [skip files from file synchronization](https://okteto.com/docs/reference/file-synchronization/index.html). This is useful to avoid synchronizing binaries or git metadata.

To run the application, execute in the remote shell:

```console
okteto> php -S 0.0.0.0:8080
```

```console
[Thu Dec 19 19:08:49 2019] PHP 7.4.1 Development Server (http://0.0.0.0:8080) started
```

Test your application by running the command below in a local shell:

```console
$ curl localhost:8080
```

```console
Hello world!
```

## Step 3: Develop directly in Kubernetes

Open the `index.php` file in your favorite local IDE and modify the response message on line 2 to be *Hello world from the cluster!*. Save your changes.

```php
<?php
$message = "Hello World from the cluster!";
echo($message);
```

Okteto will synchronize your changes to your development environment in Kubernetes, and the PHP webserver will reload them automatically. Call your application from a local shell to validate the changes:

```console
$ curl localhost:8080
```

```console
Hello world from the cluster!
```

## Step 4: Debug directly in Kubernetes

Okteto enables you to debug your applications directly from your favorite IDE. Let's take a look at how that works with [PHPStorm](https://www.jetbrains.com/phpstorm/), one of the most popular IDEs for PHP development.

If you haven't already, fire up PHP Storm and load this project there. 

Once the project is loaded, open `index.php` and set a breakpoint in line 2. Then, click on the `Start Listen PHP Debug Connections` button on the PhpStorm toolbar. 

Then call your application by running the command below from a local shell.

```console
$ curl localhost:8080
```
The execution will halt at your breakpoint. You can then inspect the request, the available variables, etc...

![Debug directly in Kubernetes](images/halt.png)

Cool! Your code changes were instantly applied to Kubernetes. No commit, build or push required 😎!

Once you are done debugging, press the `stop` button to detach from the request.

> The development environment we are using in this sample is configured to  automatically enable xdebug, remote debugging and to set a reverse tunnel on port 9000. This allows you to take advantage of PHPStorm's [Zero Configuration Debugging](https://www.jetbrains.com/help/phpstorm/zero-configuration-debugging.html) to make debugging extremely simple.

## Step 5: Cleanup

Cancel the `okteto up` command by pressing `ctrl + c` + `ctrl + d` and run the following commands to remove the resources created by this guide: 

```console
$ okteto down
```

```console
 ✓  Development environment deactivated
```

```console
$ kubectl delete -f k8s.yml
```

```console
deployment.apps "hello-world" deleted
service "hello-world" deleted
```