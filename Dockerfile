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

CMD ["/sbin/my_init"]

# Kibana Installation
WORKDIR /opt
RUN \
  add-apt-repository -y ppa:nginx/stable && \
  apt-get update -qqy && \
  apt-get install -qqy nginx && \
  curl -s -O https://download.elasticsearch.org/kibana/kibana/kibana-3.1.1.tar.gz && \
  tar xvzf kibana-3.1.1.tar.gz && \
  rm -f kibana-3.1.1.tar.gz && \
  ln -s /opt/kibana-3.1.1 /opt/kibana

ADD build/nginx.conf /etc/nginx/sites-available/default
ADD build/pfsense.json /opt/kibana/app/dashboards/pfsense.json

RUN mkdir /etc/service/kibana
ADD build/kibana.sh /etc/service/kibana/run
RUN chmod +x /etc/service/kibana/run

EXPOSE 80
# End Installation

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*