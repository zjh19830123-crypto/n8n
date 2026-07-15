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
&& echo 'exec tailscaled --tun=userspace-networking --state=/var/lib/tailscale/tailscale.state' >> /etc/sv/tailscale/run \
&& chmod +x /etc/sv/tailscale/run

RUN ln -s /etc/sv/sshd /etc/service/
RUN ln -s /etc/sv/tailscale /etc/service/

RUN curl -fsSL https://tailscale.com/install.sh | sh

RUN echo '#!/bin/sh' > /start.sh \
&& echo 'echo "等待tailscaled启动..."' >> /start.sh \
&& echo 'sleep 10' >> /start.sh \
&& echo 'echo "开始注册设备"' >> /start.sh \
&& echo 'tailscale up --force-reauth --auth-key=tskey-auth-kxgLdVzXuf11CNTRL-C36Hymfa9UQHiCeHnDugUQrJizyxzFN8Z' >> /start.sh \
&& echo 'echo "注册完成，查看设备状态"' >> /start.sh \
&& echo 'tailscale status' >> /start.sh \
&& chmod +x /start.sh

USER root

CMD ["/bin/sh","-c","/sbin/runsvdir /etc/service & /start.sh ; wait"]
