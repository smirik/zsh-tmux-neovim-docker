FROM ubuntu:18.04

# Locales
ENV LANGUAGE=en_US.UTF-8
ENV LANG=en_US.UTF-8
RUN apt-get update && apt-get install -y locales && locale-gen en_US.UTF-8

# Colors and italics for tmux
COPY xterm-256color-italic.terminfo /root
RUN tic /root/xterm-256color-italic.terminfo
ENV TERM=xterm-256color-italic

RUN apt update
RUN apt-get install -y sudo \
    docker.io

RUN adduser --home /home/smirik --shell /bin/bash --gecos --ingroup smirik --disabled-password &&\
    echo "smirik ALL=(ALL) NOPASSWD:ALL" | sudo tee -a /etc/sudoers

RUN apt-get install -y vim \
    curl \
    wget \
    git \
    zsh \
    mosh \
    tmux

RUN chsh smirik -s /usr/bin/zsh
RUN chsh root -s /usr/bin/zsh
USER smirik
RUN wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true

COPY config/zshrc /home/smirik/zshrc.original

RUN cd /home/smirik && cat zshrc.original > .zshrc && rm zshrc.original

# Install docker
#RUN  curl -o /usr/local/bin/docker-compose -L "https://github.com/docker/compose/releases/download/1.13.0/docker-compose-$(uname -s)-$(uname -m)" &&\
#     chmod +x /usr/local/bin/docker-compose
