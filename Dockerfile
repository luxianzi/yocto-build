FROM ubuntu:18.04

# -----------------
# Install packages
# -----------------
RUN apt-get update --fix-missing
RUN apt-get install -y apt-utils sudo

# Configure timezone
RUN ln -fs /usr/share/zoneinfo/Pacific/Auckland /etc/localtime
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
 tzdata

# Configure local
# https://wiki.yoctoproject.org/wiki/TipsAndTricks/ResolvingLocaleIssues
RUN apt-get install -y locales
RUN locale-gen en_US.UTF-8
RUN update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8

# Yocto dependencies
RUN apt-get install -y gawk wget git-core diffstat unzip texinfo gcc-multilib \
 build-essential chrpath socat cpio python python3 python3-pip python3-pexpect \
 xz-utils debianutils iputils-ping python3-git python3-jinja2 libegl1-mesa \
 libsdl1.2-dev pylint3 xterm gcc-multilib g++-multilib

# Development dependencies
RUN apt-get install -y rsync bsdmainutils bc vim tmux libncurses5-dev tree \
 cpio curl wget

# Cleanup apt cache and downloads to reduce file storage
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# -------------------------------------
# Create builder user and configure git
# -------------------------------------
ARG UID=1000
RUN adduser --uid $UID --disabled-password --gecos '' builder && echo \
 "builder:builder" | chpasswd
RUN adduser builder sudo
USER builder:builder
RUN echo "export LANG=en_US.UTF-8" | cat >> ~/.bashrc
RUN git config --global user.name "Yocto Build User"
RUN git config --global user.email "cosine@126.com"
WORKDIR /home/builder/

# -------------------------------------
# Setup build environment
# -------------------------------------
COPY --chown=builder:builder ./files/home/builder/bsp-init.sh \
 /home/builder/bsp-init.sh
COPY --chown=builder:builder ./build_directory \
 /home/builder/build_directory
RUN echo "source ./bsp-init.sh" | cat >> ~/.bashrc
