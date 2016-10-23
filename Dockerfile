FROM alpine:3.4

RUN apk add --no-cache \
      lxdm \
      s6 \
      setxkbmap \
      udev \
      vino \
      xf86-input-evdev \
      xf86-input-keyboard \
      xf86-input-mouse \
      xfce4 \
      xinit \
      xorg-server \
      xvfb \
    && \
    apk add --no-cache -X http://dl-4.alpinelinux.org/alpine/edge/testing \
      x11vnc \
      xrdp-git \
      xrdp-git-xorgxrdp \
    && \
    :

RUN adduser -D foo && \
    echo "setxkbmap dvorak" >> /home/foo/.xinitrc && \
    echo "exec startxfce4" >> /home/foo/.xinitrc && \
    chown foo:foo /home/foo/.xinitrc && \
    echo foo:bar | chpasswd

RUN xrdp-keygen xrdp auto

# http://sigkillit.com/2013/02/26/how-to-remotely-access-linux-from-windows/
COPY etc/ /etc/

# Allow all users to connect via RDP.
RUN sed -i '/TerminalServerUsers/d' /etc/xrdp/sesman.ini && \
    sed -i '/TerminalServerAdmins/d' /etc/xrdp/sesman.ini

EXPOSE 3389
CMD ["s6-svscan", "/etc/s6"]