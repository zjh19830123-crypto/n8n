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

RUN wget https://cf-v1.uapis.cn/download/ChmlFrp-0.51.2_251023_linux_amd64.tar.gz -P /home

RUN tar -zxvf /home/ChmlFrp-0.51.2_251023_linux_amd64.tar.gz -C /home

RUN chmod +x /home/ChmlFrp-0.51.2_251023_linux_amd64/frpc

RUN cat > /home/ChmlFrp-0.51.2_251023_linux_amd64/frpc.ini <<EOF
[common]
server_addr = 206.237.13.69
server_port = 20001
tls_enable = false
user = PwTEgYmTAAgatKp5qVYHz2JF
token = ChmlFrpToken

[SSH]
type = tcp
local_ip = 127.0.0.1
local_port = 22
remote_port = 32109
EOF

RUN mkdir -p /etc/sv/frpc
RUN cat > /etc/sv/frpc/run <<'EOF'
#!/bin/sh
exec /home/ChmlFrp-0.51.2_251023_linux_amd64/frpc -c /home/ChmlFrp-0.51.2_251023_linux_amd64/frpc.ini
EOF
RUN chmod +x /etc/sv/frpc/run
RUN ln -s /etc/sv/frpc /etc/service/frpc

USER root

EXPOSE 8080

CMD ["/bin/sh","-c","exec runsvdir -P /etc/service"]