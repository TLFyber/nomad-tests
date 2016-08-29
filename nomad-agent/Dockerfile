FROM ubuntu:16.04

MAINTAINER Ron Kurr <kurr@kurron.org>

LABEL org.kurron.ide.name="Nomad" org.kurron.ide.version=0.4.0

ADD https://releases.hashicorp.com/nomad/0.4.0/nomad_0.4.0_linux_amd64.zip /tmp/ide.zip

RUN apt-get update && \
    apt-get install -y unzip ca-certificates apt-transport-https && \
    unzip /tmp/ide.zip -d /usr/local/bin && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/*

# For docker-engine
RUN echo 'deb https://apt.dockerproject.org/repo ubuntu-xenial main' > /etc/apt/sources.list.d/docker.list
RUN apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D

# Install packages
RUN apt-get update
RUN apt-get install -y docker-engine

RUN chmod +x /usr/local/bin/nomad

ADD "entrypoint.sh" "/entrypoint.sh"
ADD "drainable.nomad" "/drainable.nomad"

RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
