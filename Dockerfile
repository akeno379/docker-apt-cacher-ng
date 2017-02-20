FROM ubuntu:16.04
MAINTAINER hi181904665@gmail.com

ENV APT_CACHER_NG_CACHE_DIR=/var/cache/apt-cacher-ng \
    APT_CACHER_NG_LOG_DIR=/var/log/apt-cacher-ng \
    APT_CACHER_NG_USER=apt-cacher-ng

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y apt-cacher-ng iputils-ping cron \
 && rm -rf /var/lib/apt/lists/*

COPY entrypoint.sh /sbin/entrypoint.sh
RUN chmod 755 /sbin/entrypoint.sh

COPY ubuntu_mirrors /etc/apt-cacher-ng/ubuntu_mirrors
RUN chmod 644 /etc/apt-cacher-ng/ubuntu_mirrors
COPY centos_mirrors /etc/apt-cacher-ng/centos_mirrors
RUN chmod 644 /etc/apt-cacher-ng/centos_mirrors


# Run any additional tasks here that are too tedious to put in
# this dockerfile directly.
ADD setup.sh /setup.sh
RUN chmod 0755 /setup.sh
RUN /setup.sh

EXPOSE 3142/tcp
VOLUME ["${APT_CACHER_NG_CACHE_DIR}"]
ENTRYPOINT ["/sbin/entrypoint.sh"]
CMD ["/usr/sbin/apt-cacher-ng"]
