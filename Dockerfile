FROM ubuntu:20.04

# 设置环境变量，避免交互式安装时的提示
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    wget \
    x11vnc \
    xvfb \
    fluxbox \
    xterm \
    net-tools \
    iproute2 \
    iptables \
    curl \
    dante-server \
    libgtk2.0-0 \
    libglib2.0-dev \
    xclip \
    xsel \
    libalgorithm-c3-perl \
    libb-hooks-endofscope-perl \
    libb-hooks-op-check-perl \
    libclass-c3-perl \
    libclass-c3-xs-perl \
    libclass-data-inheritable-perl \
    libclass-inspector-perl \
    libclass-method-modifiers-perl \
    libclass-singleton-perl \
    libclass-xsaccessor-perl \
    libdata-optlist-perl \
    libdatetime-locale-perl \
    libdatetime-perl \
    libdatetime-timezone-perl \
    libdevel-callchecker-perl \
    libdevel-caller-perl \
    libdevel-lexalias-perl \
    libdevel-stacktrace-perl \
    libdynaloader-functions-perl \
    libeval-closure-perl \
    libexception-class-perl \
    libexporter-tiny-perl \
    libfile-sharedir-perl \
    libgbm1 \
    libgomp1 \
    libhash-merge-simple-perl \
    liblist-moreutils-perl \
    libmodule-implementation-perl \
    libmodule-runtime-perl \
    libmro-compat-perl \
    libnamespace-autoclean-perl \
    libnamespace-clean-perl \
    libpackage-stash-perl \
    libpackage-stash-xs-perl \
    libpadwalker-perl \
    libparams-classify-perl \
    libparams-util-perl \
    libparams-validationcompiler-perl \
    libreadonly-perl \
    libref-util-perl \
    libref-util-xs-perl \
    librole-tiny-perl \
    libspecio-perl \
    libsub-exporter-perl \
    libsub-exporter-progressive-perl \
    libsub-identify-perl \
    libsub-install-perl \
    libsub-name-perl \
    libsub-quote-perl \
    libswitch-perl \
    libtry-tiny-perl \
    libvariable-magic-perl \
    libwayland-server0 \
    libxstring-perl \
    libyaml-tiny-perl \
    ssl-cert \
    x11-xserver-utils \
    && rm -rf /var/lib/apt/lists/*

COPY ./assets/inode.arm64_E0626.deb /tmp/inode.deb
RUN dpkg -i /tmp/inode.deb || apt-get install -y -f
RUN rm -f /tmp/inode.deb

# 下载并安装 KasmVNC
RUN wget https://github.com/kasmtech/KasmVNC/releases/download/v1.3.3/kasmvncserver_focal_1.3.3_arm64.deb -O /tmp/kasmvnc.deb \
    && dpkg -i /tmp/kasmvnc.deb || apt-get install -y -f \
    && rm -f /tmp/kasmvnc.deb

# 启动脚本
COPY start-vnc.sh /home/vncuser/start-vnc.sh

# 启动 VNC 服务
CMD ["/home/vncuser/start-vnc.sh"]
