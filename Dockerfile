FROM ubuntu:latest
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Shanghai DEBIAN_FRONTEND=noninteractive
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
    openssh-server \
    ubuntu-minimal \
    ubuntu-server-minimal
RUN apt install language-pack-zh-hans xfce4-terminal -y
RUN locale-gen zh_CN.UTF-8
RUN update-locale LANG=zh_CN.UTF-8 LC_ALL=zh_CN.UTF-8
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
CMD ["/bin/sh","-c","exec runsvdir -P /etc/service"]
