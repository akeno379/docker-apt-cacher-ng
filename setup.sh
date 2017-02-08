sed 's/# ForeGround: 0/ForeGround: 1/' -i /etc/apt-cacher-ng/acng.conf \
 && echo 'PassThroughPattern: (packages-gitlab-com\.s3\.amazonaws\.com|packages-gitlab-com\.s3-accelerate\.amazonaws\.com|packages\.gitlab\.com|mirrors\.fedoraproject\.org):443 | get\.docker\.com|download\.oracle\.com' >> /etc/apt-cacher-ng/acng.conf \
 && echo 'VfilePatternEx: ^(/\?release=[0-9]+&arch=.*)$' >>  /etc/apt-cacher-ng/acng.conf \
 && echo 'Remap-centos: file:centos_mirrors ; http://mirror.ox.ac.uk/sites/mirror.centos.org/' >>  /etc/apt-cacher-ng/acng.conf \
 && echo 'PrecacheFor: */dists/* ' >> /etc/apt-cacher-ng/acng.conf \
 && echo 'Offlinemode : 0' >>  /etc/apt-cacher-ng/acng.conf 
