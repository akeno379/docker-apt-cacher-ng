# akeno379/apt-cacher-ng:latest

- [Introduction](#introduction)
- [Switching offline mode](#switching-offline-mode)
- [Getting started](#getting-started)
  - [Installation](#installation)
  - [Quickstart](#quickstart)
  - [Usage](#usage)
  - [Upgrading](#upgrading)
  - [Shell Access](#shell-access)
- [Further help](#further-help)

***

# Introduction

This git repository helps you installing and running [Apt-Cacher NG](https://www.unix-ag.uni-kl.de/~bloch/acng/) quickly on your local machine.

Apt-Cacher NG is a caching proxy, specialized for package files from Linux distributors, primarily for [Debian](http://www.debian.org/) (and [Debian based](https://en.wikipedia.org/wiki/List_of_Linux_distributions#Debian-based)) distributions but not limited to those.

This repository is to create a [Docker](https://www.docker.com/) container image for Apt-Cacher NG.It is a modified version of [sameersbn/docker-apt-cacher-ng](https://github.com/sameersbn/docker-apt-cacher-ng),  [lurcio/docker-apt-cacher-ng](https://github.com/lurcio/docker-apt-cacher-ng) and [seifer08ms/docker-apt-cacher-ng](https://github.com/seifer08ms/docker-apt-cacher-ng) with a few changes including docker compose version, updated the docker FROM image, and updated the [setup.sh](https://github.com/akeno379/docker-apt-cacher-ng/blob/master/setup.sh) to cache the packages/indexes from SSL/TLS(HTTPS). Many thanks guys!

# Switching offline mode

This feature is the major update from original codes. The Docker container can automatically check network and choose offline or online mode in the beginning of startup. If the network condition is change during running, you can restart it to check it again using `docker restart apt-cacher-ng`. 

# Getting started

## Installation

Automated builds of the image are available on [Dockerhub](https://hub.docker.com/r/lurcio/apt-cacher-ng) and is the recommended method of installation.

```bash
docker pull akeno379/apt-cacher-ng:latest
```

Alternatively you can build the image yourself with make command.

```bash
make
```

## Quickstart

Start Apt-Cacher NG daemon using:

```bash
make install HOST_CACHE_DIR=/srv/docker/apt-cacher-ng
```
This commnad could mounts a volume for persistence. The parameter `HOST_CACHE_DIR` denotes the location of mounting a volume at `/var/cache/apt-cacher-ng`.

*Alternatively, you can use the sample [docker-compose.yml](docker-compose.yml) file to start the container using [Docker Compose](https://docs.docker.com/compose/)*

## Usage

To start using Apt-Cacher NG on your Debian (and Debian based) host, create the configuration file `/etc/apt/apt.conf.d/01proxy` with the following content:

```config
Acquire::HTTP::Proxy "http://172.17.42.1:3142";
Acquire::HTTPS::Proxy "false";
```

Similarly, to use Apt-Cacher NG in you Docker containers add the following line to your `Dockerfile` before any `apt-get` commands.

```dockerfile
RUN echo 'Acquire::HTTP::Proxy "http://172.17.42.1:3142";' >> /etc/apt/apt.conf.d/01proxy \
 && echo 'Acquire::HTTPS::Proxy "false";' >> /etc/apt/apt.conf.d/01proxy
```

By default apt-cacher-ng doesn't cache the packages/indexes from SSL/TLS(HTTPS). To make apt-cacher-ng cache the packages/indexes via SSL/TLS repositories, we will have to configure apt-cacher-ng to remap a chosen non-https repository url to the actual https url.

Create a file named backends_packages in /etc/apt-cacher-ng that looks like:

```
https://download.docker.com/linux/ubuntu
```

Now, in apt-cacher-ng /etc/apt-cacher-ng/acng.conf we can specify a mapping like:

```
#Remap-RepositoryName: MergingURLs ; TargetURLs ; OptionalFlags

Remap-docker: http://fakedomain.com ; file:backends_packages
```

We can now configure all our clients to use http://fakedomain.com instead of https://download.docker.com/linux/ubuntu, and apt-cacher-ng will transparently proxy, and more importantly, cache, objects from https://download.docker.com/linux/ubuntu. For more example check the [setup.sh](https://github.com/akeno379/docker-apt-cacher-ng/blob/master/setup.sh).

_Note: You may need to add the GPG Key to the machine that uses the proxy._

## Upgrading

To upgrade to newer releases:

  1. Download the updated Docker image:

  ```bash
  make pull
  ```

  2. Stop and remove the container:

  ```bash
  make clean
  ```

  4. Start the updated image

  ```bash
  make install
  ```

## Shell Access

For debugging and maintenance purposes you may want access the containers shell:

```bash
make shell
```

# Further help

See also [lurcio/docker-apt-cacher-ng](https://github.com/lurcio/docker-apt-cacher-ng)

