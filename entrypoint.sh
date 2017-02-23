#!/bin/bash
set -e

create_pid_dir() {
  mkdir -p /run/apt-cacher-ng
  chmod -R 0755 /run/apt-cacher-ng
  chown ${APT_CACHER_NG_USER}:${APT_CACHER_NG_USER} /run/apt-cacher-ng
}

create_cache_dir() {
  mkdir -p ${APT_CACHER_NG_CACHE_DIR}
  chmod -R 0755 ${APT_CACHER_NG_CACHE_DIR}
  chown -R ${APT_CACHER_NG_USER}:root ${APT_CACHER_NG_CACHE_DIR}
}

create_log_dir() {
  mkdir -p ${APT_CACHER_NG_LOG_DIR}
  chmod -R 0755 ${APT_CACHER_NG_LOG_DIR}
  chown -R ${APT_CACHER_NG_USER}:${APT_CACHER_NG_USER} ${APT_CACHER_NG_LOG_DIR}
}

create_pid_dir
create_cache_dir
create_log_dir

PROXY_SERVER=${PROXY_SERVER:-proxy_server}
#DISABLE_PROXY=${DISABLE_PROXY:-0}
PROXY_PORT=${PROXY_PORT:-8087}
PROXY_CHECK_INTVL=${PROXY_CHECK_INTVL:-320}
PROXY_TIMEOUT=${PROXY_TIMEOUT:-3}

if [  -z "$DISABLE_PROXY"  -o  "$DISABLE_PROXY" =  "0" ];then
 echo "proxy is enable..."
 sed -i "/Proxy\s\{0,\}:/c\Proxy:http:\/\/${PROXY_SERVER}:${PROXY_PORT} " /etc/apt-cacher-ng/acng.conf
 sed -i "/OptProxyCheckInterval\s\{0,\}:/c\OptProxyCheckInterval: ${PROXY_CHECK_INTVL}" /etc/apt-cacher-ng/acng.conf
 sed -i "/OptProxyTimeout\s\{0,\}:/c\OptProxyTimeout: ${PROXY_TIMEOUT}" /etc/apt-cacher-ng/acng.conf
else  
 echo "proxy is disable..."
 sed -i "/Proxy\s\{0,\}:/c\#Proxy:" /etc/apt-cacher-ng/acng.conf
 sed -i "/OptProxyCheckInterval\s\{0,\}:/c\#OptProxyCheckInterval:" /etc/apt-cacher-ng/acng.conf
 sed -i "/OptProxyTimeout\s\{0,\}:/c\#OptProxyTimeout:" /etc/apt-cacher-ng/acng.conf
fi



offline_mode() {
  sed "s/Offlinemode\s\{0,\}:\s\{0,\}[01]/Offlinemode : $1/" -i /etc/apt-cacher-ng/acng.conf
}

if ping -q -c 1 -W 1 8.8.8.8 >/dev/null; then
  offline_mode 0
  echo "apt-cacher-ng will running with online mode ...."
else
  offline_mode 1
  echo "Warning: apt-cacher-ng will running with offline mode ...."
fi


# allow arguments to be passed to apt-cacher-ng
if [[ ${1:0:1} = '-' ]]; then
  EXTRA_ARGS="$@"
  set --
elif [[ ${1} == apt-cacher-ng || ${1} == $(which apt-cacher-ng) ]]; then
  EXTRA_ARGS="${@:2}"
  set --
fi

# default behaviour is to launch apt-cacher-ng
if [[ -z ${1} ]]; then
  exec start-stop-daemon --start --chuid ${APT_CACHER_NG_USER}:${APT_CACHER_NG_USER} \
    --exec $(which apt-cacher-ng) -- -c /etc/apt-cacher-ng ${EXTRA_ARGS}
else
  exec "$@"
fi

export ACNGREQ="?abortOnErrors=aOe&byPath=bP&byChecksum=bS&truncNow=tN&incomAsDamaged=iad&purgeNow=pN&doExpire=Start+Scan+and%2For+Expiration&calcSize=cs&asNeeded=an"

/usr/lib/apt-cacher-ng/acngtool maint
