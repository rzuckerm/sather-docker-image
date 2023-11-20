FROM archlinux:base-20231112.0.191179

COPY SATHER_* /tmp/
ENV SATHER_HOME=/usr/lib/sather
RUN pacman -Syu --noconfirm && \
    pacman -Sy --noconfirm git fakeroot make gcc gc tcl tk && \
    useradd sather
USER sather
WORKDIR /home/sather
RUN cd /home/sather && \
    git clone https://github.com/aur-archive/sather && \
    cd sather && \
    git reset --hard $(cat /tmp/SATHER_COMMIT_HASH) && \
    makepkg
USER root
WORKDIR /
RUN cp -rp /home/sather/sather/pkg/sather/usr/* /usr/ && \
    pacman -Rcns --noconfirm git fakeroot && \
    userdel sather && \
    rm -rf /home/sather /var/lib/pacmam/local/*
