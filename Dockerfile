FROM ubuntu:latest

ENV DEBIAN_FRONTEND=noninteractive

RUN cat > /etc/apt/sources.list <<'EOF'
deb http://archive.ubuntu.com/ubuntu/ noble main restricted universe multiverse
deb http://archive.ubuntu.com/ubuntu/ noble-security main restricted universe multiverse
deb http://archive.ubuntu.com/ubuntu/ noble-updates main restricted universe multiverse
deb http://archive.ubuntu.com/ubuntu/ noble-backports main restricted universe multiverse
EOF

RUN apt-get update && apt-get install -y \
    curl \
    sudo \
    git \
    wget \
    build-essential \
    python3 \
    python3-pip \
    nano \
    zip \
    unzip \
    tar \
    gzip \
    bzip2 \
    runit \
    unminimize \
    net-tools \
    iproute2 \
    ca-certificates \
    tzdata \
    procps \
    lsb-release \
    less \
    iputils-ping \
    traceroute \
    dnsutils \
    file \
    tree \
    htop \
    vim \
    locales \
    software-properties-common \
    ncdu \
    util-linux \
    fdisk \
    telnet \
    tcpdump \
    rsync \
    jq \
    ripgrep \
    watch \
    bc \
    passwd \
    default-jdk \
    man-db \
    diffutils \
    patch \
    groff-base \
    mtr \
    bsdmainutils

RUN yes | unminimize

RUN curl -fsSL https://code-server.dev/install.sh | sh

RUN mkdir -p /etc/sv/code-server
RUN cat > /etc/sv/code-server/run <<'EOF'
#!/bin/sh
exec code-server --bind-addr 0.0.0.0:8080 --auth none
EOF
RUN chmod +x /etc/sv/code-server/run
RUN ln -s /etc/sv/code-server /etc/service/

USER root

EXPOSE 8080

CMD ["/bin/sh","-c","exec runsvdir -P /etc/service"]