FROM ubuntu:18.04

# Locales
ENV LANGUAGE=en_US.UTF-8
ENV LANG=en_US.UTF-8

RUN apt-get update && apt-get install -y locales && locale-gen en_US.UTF-8

RUN apt-get update && apt-get install -y vim \
    sudo \
    curl \
    wget \
    git \
    zsh \
    openssh-server \
    mosh \
    tmux \
    docker.io

COPY config/sshd_config /etc/ssh/sshd_config
RUN mkdir /var/run/sshd
# RUN /etc/init.d/sshd start > /dev/null 2>&1

#RUN update-rc add sshd \
#    && rc-status \
#    && touch /run/openrc/softlevel \
#    && /etc/init.d/sshd start > /dev/null 2>&1 \
#    && /etc/init.d/sshd stop > /dev/null 2>&1

#              ssh   mosh
EXPOSE 80 8080 62222 60001/udp

RUN adduser --home /home/smirik --shell /bin/bash --gecos --ingroup smirik --disabled-password &&\
    echo "smirik ALL=(ALL) NOPASSWD:ALL" | sudo tee -a /etc/sudoers

# Colors and italics for tmux
COPY config/xterm-256color-italic.terminfo /home/smirik/
RUN tic /home/smirik/xterm-256color-italic.terminfo
ENV TERM=xterm-256color-italic

RUN chsh smirik -s /usr/bin/zsh
RUN chsh root -s /usr/bin/zsh

#USER smirik
#RUN wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true

COPY config/zshrc /home/smirik/zshrc.original

RUN cd /home/smirik && cat zshrc.original > .zshrc && rm zshrc.original

COPY config/start.bash /usr/local/bin/start.bash
ENTRYPOINT ["zsh", "/usr/local/bin/start.bash"]

# Install docker
#RUN  curl -o /usr/local/bin/docker-compose -L "https://github.com/docker/compose/releases/download/1.13.0/docker-compose-$(uname -s)-$(uname -m)" &&\
#     chmod +x /usr/local/bin/docker-compose
