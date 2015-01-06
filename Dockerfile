FROM phusion/baseimage:latest

MAINTAINER Maurice Kaag <mkaag@me.com>

ENV HOME /root
ENV DEBIAN_FRONTEND noninteractive
ENV DEBIAN_PRIORITY critical
ENV DEBCONF_NOWARNINGS yes
# Workaround initramfs-tools running on kernel 'upgrade': <http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=594189>
ENV INITRD No

# Workaround initscripts trying to mess with /dev/shm: <https://bugs.launchpad.net/launchpad/+bug/974584>
# Used by our `src/ischroot` binary to behave in our custom way, to always say we are in a chroot.
ENV FAKE_CHROOT 1
RUN mv /usr/bin/ischroot /usr/bin/ischroot.original
ADD build/ischroot /usr/bin/ischroot

# Configure no init scripts to run on package updates.
ADD build/policy-rc.d /usr/sbin/policy-rc.d

# Disable SSH
RUN rm -rf /etc/service/sshd /etc/my_init.d/00_regen_ssh_host_keys.sh

# Ensure UTF-8
RUN locale-gen en_US.UTF-8
ENV LANG       en_US.UTF-8
ENV LC_ALL     en_US.UTF-8

CMD ["/sbin/my_init"]

# Kibana Installation
ENV KIBANA_VERSION 3.1.2

WORKDIR /opt
RUN \
  add-apt-repository -y ppa:nginx/stable && \
  apt-get update -qqy && \
  apt-get install -qqy nginx && \
  curl -s -O https://download.elasticsearch.org/kibana/kibana/kibana-$KIBANA_VERSION.tar.gz && \
  tar xvzf kibana-$KIBANA_VERSION.tar.gz && \
  rm -f kibana-$KIBANA_VERSION.tar.gz && \
  ln -s /opt/kibana-$KIBANA_VERSION /opt/kibana && \
  echo "daemon off;" >> /etc/nginx/nginx.conf

ADD build/default /etc/nginx/sites-available/default
ADD build/nginx.conf /etc/nginx/nginx.conf
ADD build/pfsense.json /opt/kibana/app/dashboards/pfsense.json

RUN mkdir /etc/service/kibana
ADD build/kibana.sh /etc/service/kibana/run
RUN chmod +x /etc/service/kibana/run

EXPOSE 80
# End Installation

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
