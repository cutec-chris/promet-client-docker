FROM hurricane/dockergui:x11rdp1.3
MAINTAINER Christian U. <github.c@ullihome.de>

# User/Group Id gui app will be executed as default are 99 and 100
ENV USER_ID=99
ENV GROUP_ID=100

# Gui App Name default is "GUI_APPLICATION"
ENV APP_NAME="Promet-ERP"

# Default resolution, change if you like
ENV WIDTH=1280
ENV HEIGHT=720

# Use baseimage-docker's init system
CMD ["/sbin/my_init"]

RUN \
#########################################
##    REPOSITORIES AND DEPENDENCIES    ##
#########################################
echo 'deb http://archive.ubuntu.com/ubuntu trusty main universe restricted' > /etc/apt/sources.list && \
echo 'deb http://archive.ubuntu.com/ubuntu trusty-updates main universe restricted' >> /etc/apt/sources.list && \
mkdir -p /etc/my_init.d && \

# Install packages needed for app
export DEBCONF_NONINTERACTIVE_SEEN=true DEBIAN_FRONTEND=noninteractive && \
apt-get update

# Installing packages
RUN apt-get install wget sqlite3 -y
RUN apt-get install libfreetype6 libdbus-1-3 -y
RUN wget http://downloads.free-erp.de/promet-erp_7.0.432_amd64-gtk2.deb && dpkg -i promet-erp_7.0.432_amd64-gtk2.deb && rm promet-erp_7.0.432_amd64-gtk2.deb
RUN apt-get clean && apt-get autoremove -y

# Copy X app start script to right location
COPY startapp.sh /startapp.sh
COPY firstrun.sh /etc/my_init.d/firstrun.sh
COPY /src/jd2.tar /nobody/jd2.tar
RUN chmod +x /etc/my_init.d/firstrun.sh 
EXPOSE 80
VOLUME ["/srv/promet", "/var/log"]