FROM ubuntu:latest

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    curl \
    sudo \
    git \
    wget \
    build-essential \
    zip \
    unzip \
    tar \
    gzip \
    bzip2 \
    openssh-server \
    net-tools \
    nano \
    runit

RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

RUN mkdir -p /etc/sv/sshd
RUN echo '#!/bin/sh' > /etc/sv/sshd/run \
&& echo 'exec /usr/sbin/sshd -D' >> /etc/sv/sshd/run \
&& chmod +x /etc/sv/sshd/run

RUN mkdir -p /etc/sv/tailscale
RUN echo '#!/bin/sh' > /etc/sv/tailscale/run \
&& echo 'exec tailscaled --tun=userspace-networking --state=/var/lib/tailscale/tailscale.state --verbose' >> /etc/sv/tailscale/run \
&& chmod +x /etc/sv/tailscale/run

RUN ln -s /etc/sv/sshd /etc/service/
RUN ln -s /etc/sv/tailscale /etc/service/

RUN curl -fsSL https://tailscale.com/install.sh | sh

RUN echo '#!/bin/sh' > /register.sh \
&& echo 'sleep 8' >> /register.sh \
&& echo 'tailscale up --force-reauth --login-server=https://login.tailscale.com --auth-key=tskey-auth-kjFcKg6gtL11CNTRL-pvwYk7Baed1KgzhXLZzCe1NvnZnzAyzZ' >> /register.sh \
&& echo 'tailscale status >> /tailscale.log' >> /register.sh \
&& chmod +x /register.sh

RUN echo '#!/bin/sh' > /entry.sh \
&& echo '/register.sh &' >> /entry.sh \
&& echo 'exec /sbin/runsvdir /etc/service' >> /entry.sh \
&& chmod +x /entry.sh

USER root

CMD ["/bin/sh","/entry.sh"]
