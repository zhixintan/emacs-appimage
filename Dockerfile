FROM ubuntu:26.04

ENV DEBIAN_FRONTEND=noninteractive WORK_DIR=/work DIST_DIR=/work/dist DIST_APPDIR=/work/dist/AppDir

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Shanghai

RUN printf '%s\n' \
    'Types: deb' \
    'URIs: http://mirrors.tuna.tsinghua.edu.cn/ubuntu' \
    'Suites: resolute resolute-updates resolute-backports' \
    'Components: main restricted universe multiverse' \
    'Signed-By: /usr/share/keyrings/ubuntu-archive-keyring.gpg' \
    '' \
    'Types: deb' \
    'URIs: http://mirrors.tuna.tsinghua.edu.cn/ubuntu' \
    'Suites: resolute-security' \
    'Components: main restricted universe multiverse' \
    'Signed-By: /usr/share/keyrings/ubuntu-archive-keyring.gpg' \
    > /etc/apt/sources.list.d/ubuntu.sources

RUN mkdir -p $WORK_DIR $DIST_DIR $DIST_APPDIR
WORKDIR $WORK_DIR

# 安装 ca-certificates 后，把源切换为 HTTPS
RUN apt-get update && \
    apt-get install -y --no-install-recommends ca-certificates tzata && \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    echo $TZ > /etc/timezone && \
    dpkg-reconfigure --frontend noninteractive tzdata && \
    sed -i 's|http://mirrors.tuna.tsinghua.edu.cn|https://mirrors.tuna.tsinghua.edu.cn|g' /etc/apt/sources.list.d/ubuntu.sources && \
    rm -rf /var/lib/apt/lists/*


# deps for gcc
RUN apt-get update && apt-get install -y \
    xz-utils wget nano libtree-sitter-dev libgccjit-15-dev \
    build-essential g++ make file \
    libgmp-dev libmpfr-dev libmpc-dev \
    xorg libx11-dev libgtk-3-dev libxaw7-dev \
    libjpeg-dev libgif-dev libtiff-dev libxmp-dev \
    libsqlite3-dev libmagickcore-dev libmagickwand-dev \
    libwebp-dev libotf-dev libcairo-dev libjansson-dev \
    libgnutls28-dev libxpm-dev libncurses-dev  libselinux-dev \
    git texinfo pax-utils && \
    gcc bison patchelf && \
    rm -rf /var/lib/apt/lists/*

ADD scripts /work/scripts
