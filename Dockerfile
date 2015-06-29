FROM mkaag/baseimage:latest
MAINTAINER Maurice Kaag <mkaag@me.com>

# -----------------------------------------------------------------------------
# Environment variables
# -----------------------------------------------------------------------------
ENV KIBANA_VERSION 4.1.1-linux-x64

# -----------------------------------------------------------------------------
# Pre-install
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# Install
# -----------------------------------------------------------------------------
WORKDIR /opt
RUN \
  curl -s -O https://download.elastic.co/kibana/kibana/kibana-${KIBANA_VERSION}.tar.gz && \
  tar xvzf kibana-${KIBANA_VERSION}.tar.gz && \
  rm -f kibana-${KIBANA_VERSION}.tar.gz && \
  ln -s /opt/kibana-${KIBANA_VERSION} /opt/kibana

# -----------------------------------------------------------------------------
# Post-install
# -----------------------------------------------------------------------------
RUN mkdir /etc/service/kibana
ADD build/kibana.sh /etc/service/kibana/run
RUN chmod +x /etc/service/kibana/run

EXPOSE 5601

CMD ["/sbin/my_init"]

# -----------------------------------------------------------------------------
# Clean up
# -----------------------------------------------------------------------------
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
