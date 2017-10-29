#!/bin/bash

sed 's/# ForeGround: 0/ForeGround: 1/' -i /etc/apt-cacher-ng/acng.conf \
 && echo 'VfilePatternEx: ^(/\?release=[0-9]+&arch=.*)$|(^|.*?/)(Index|Packages\.bz2|Packages\.gz|Packages|Release|Release\.gpg|Sources\.bz2|Sources\.gz|Sources|release|index\.db-.*\.gz|Contents-[^/]*\.gz|pkglist[^/]*\.bz2|rclist[^/]*\.bz2|/meta-release[^/]*|Translation[^/]*\.bz2|.*\.db)$' >>  /etc/apt-cacher-ng/acng.conf \
 && echo 'Remap-centos: file:centos_mirrors ; http://mirror.ox.ac.uk/sites/mirror.centos.org/' >>  /etc/apt-cacher-ng/acng.conf \
 && echo 'Remap-docker: http://proxydocker.com ; file:backends_docker' >>  /etc/apt-cacher-ng/acng.conf \
 && echo 'Remap-dotnet: http://proxydotnet.com ; file:backends_dotnet' >>  /etc/apt-cacher-ng/acng.conf \
 && echo 'Remap-node8: http://proxynode8.com ; file:backends_node8' >>  /etc/apt-cacher-ng/acng.conf \
 && echo 'PrecacheFor: debrep/dists/*/main/binary-amd64/* uburep/dists/*/main/binary-amd64/Packages* ' >> /etc/apt-cacher-ng/acng.conf \
 && echo 'ReuseConnections: 0 '>> /etc/apt-cacher-ng/acng.conf \
 && echo 'Offlinemode : 0' >>  /etc/apt-cacher-ng/acng.conf 

echo 'Acquire::http { Proxy "http://localhost:3142"; };' | tee /etc/apt/apt.conf.d/02proxy
sed -i '8s/^/export ACNGREQ="?abortOnErrors=aOe&byPath=bP&byChecksum=bS&truncNow=tN&incomAsDamaged=iad&purgeNow=pN&doExpire=Start+Scan+and%2For+Expiration&calcSize=cs&asNeeded=an"/' /etc/cron.daily/apt-cacher-ng

echo "0 * * * * /etc/cron.daily/apt-cacher-ng" >> maint_cron
crontab maint_cron
rm maint_cron
