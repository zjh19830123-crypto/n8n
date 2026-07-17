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
    bsdmainutils \
    openssh-server

RUN yes | unminimize

RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

RUN mkdir -p /etc/sv/sshd
RUN cat > /etc/sv/sshd/run <<'EOF'
#!/bin/sh
exec /usr/sbin/sshd -D
EOF
RUN chmod +x /etc/sv/sshd/run
RUN ln -s /etc/sv/sshd /etc/service/

RUN echo 'root:@Awf123456789' | chpasswd

USER root

EXPOSE 22

CMD ["/bin/sh","-c","exec runsvdir -P /etc/service"]