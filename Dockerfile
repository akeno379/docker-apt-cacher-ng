FROM debian:stretch-slim
MAINTAINER akeno.nakamura@gmail.com

ENV APT_CACHER_NG_CACHE_DIR=/var/cache/apt-cacher-ng \
    APT_CACHER_NG_LOG_DIR=/var/log/apt-cacher-ng \
    APT_CACHER_NG_USER=apt-cacher-ng \
    DISABLE_PROXY=1

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y apt-cacher-ng iputils-ping cron ca-certificates apt-transport-https gnupg2 software-properties-common \
 && rm -rf /var/lib/apt/lists/*

COPY entrypoint.sh /sbin/entrypoint.sh
RUN chmod 755 /sbin/entrypoint.sh

COPY ubuntu_mirrors /etc/apt-cacher-ng/ubuntu_mirrors
RUN chmod 644 /etc/apt-cacher-ng/ubuntu_mirrors
COPY centos_mirrors /etc/apt-cacher-ng/centos_mirrors
RUN chmod 644 /etc/apt-cacher-ng/centos_mirrors
COPY backends_docker /etc/apt-cacher-ng/backends_docker
RUN chmod 644 /etc/apt-cacher-ng/backends_docker
COPY backends_dotnet /etc/apt-cacher-ng/backends_dotnet
RUN chmod 644 /etc/apt-cacher-ng/backends_dotnet
COPY backends_node8 /etc/apt-cacher-ng/backends_node8
RUN chmod 644 /etc/apt-cacher-ng/backends_node8

# Run any additional tasks here that are too tedious to put in
# this dockerfile directly.
ADD setup.sh /setup.sh
RUN chmod 0755 /setup.sh
RUN /setup.sh

EXPOSE 3142/tcp
VOLUME ["${APT_CACHER_NG_CACHE_DIR}"]
ENTRYPOINT ["/sbin/entrypoint.sh"]
CMD ["/usr/sbin/apt-cacher-ng"]
