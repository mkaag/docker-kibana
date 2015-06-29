## kibana Dockerfile

This repository contains the **Dockerfile** and the configuration files of [Kibana](http://www.elasticsearch.org/overview/kibana/) for [Docker](https://www.docker.com/).

### Base Docker Image

* [phusion/baseimage](https://github.com/phusion/baseimage-docker), the *minimal Ubuntu base image modified for Docker-friendliness*...
* ...[including image's enhancement](https://github.com/racker/docker-ubuntu-with-updates) from [Paul Querna](https://journal.paul.querna.org/articles/2013/10/15/docker-ubuntu-on-rackspace/)
* ...run script inspired by [Ian Babrou](https://github.com/bobrik/docker-kibana/blob/master/run.sh)

### Installation

`docker build -t mkaag/kibana github.com/mkaag/docker-kibana`

### Usage

```bash
docker run -d -p 5601:5601 \
--link elasticsearch:es \
-e KIBANA_INDEX=logstash-* \
mkaag/kibana
```
