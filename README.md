# seifer08ms/apt-cacher-ng:latest

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

This repository is to create a [Docker](https://www.docker.com/) container image for Apt-Cacher NG.It is a modified version of [sameersbn/docker-apt-cacher-ng](https://github.com/sameersbn/docker-apt-cacher-ng) and [lurcio/docker-apt-cacher-ng](https://github.com/lurcio/docker-apt-cacher-ng) with a few changes including ubuntu mirrors list, extended Makefile and switching offline mode. Many thanks sameersbn and lurcio!

# Switching offline mode

This feature is the major update from original codes. The Docker container can automatically check network and choose offline or online mode in the beginning of startup. If the network condition is change during running, you can restart it to check it again using `docker restart apt-cacher-ng`. 

# Getting started

## Installation

Automated builds of the image are available on [Dockerhub](https://hub.docker.com/r/lurcio/apt-cacher-ng) and is the recommended method of installation.

```bash
docker pull seifer_08ms/apt-cacher-ng:latest
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

