FROM lsiobase/xenial-root-armhf
MAINTAINER sparklyballs

# set version for s6 overlay
ARG OVERLAY_VERSION="v1.19.1.1"
ARG OVERLAY_ARCH="armhf"

# set environment variables
ARG DEBIAN_FRONTEND="noninteractive"
ENV HOME="/root" \
LANGUAGE="en_US.UTF-8" \
LANG="en_US.UTF-8" \
TERM="xterm"

# copy sources
COPY sources.list /etc/apt/

# generate locale
RUN \
 locale-gen en_US.UTF-8 && \

# install apt-utils
 apt-get update && \
 apt-get install -y \
	apt-utils && \

# install packages
 apt-get install -y \
	curl && \

# add s6 overlay
 curl -o \
 /tmp/s6-overlay.tar.gz -L \
	"https://github.com/just-containers/s6-overlay/releases/download/${OVERLAY_VERSION}/s6-overlay-${OVERLAY_ARCH}.tar.gz" && \
 tar xfz \
	/tmp/s6-overlay.tar.gz -C / && \

# create abc user
 useradd -u 911 -U -d /config -s /bin/false abc && \
 usermod -G users abc && \

# make our folders
 mkdir -p \
	/app \
	/config \
	/defaults && \

# cleanup
 apt-get clean && \
 rm -rf \
	/tmp/* \
	/var/lib/apt/lists/* \
	/var/tmp/*

# add local files
COPY root/ /

ENTRYPOINT ["/init"]
