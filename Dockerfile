# Elasticsearch Dockerfile
#
#     https://github.com/dockerfile/elasticsearch
#
FROM openjdk:8-jre

ENV ELASTICSEARCH_VERSION 2.3.5
ENV PATH /usr/share/elasticsearch/bin:$PATH

# https://www.elastic.co/guide/en/elasticsearch/reference/current/setup-repositories.html
# https://packages.elasticsearch.org/GPG-KEY-elasticsearch
RUN apt-key adv --keyserver ha.pool.sks-keyservers.net --recv-keys 46095ACC8548582C1A2699A9D27D666CD88E42B4
RUN echo "deb http://packages.elasticsearch.org/elasticsearch/2.x/debian stable main" > /etc/apt/sources.list.d/elasticsearch.list
RUN set -x \
  && apt-get update \
  && apt-get install -y --no-install-recommends elasticsearch=$ELASTICSEARCH_VERSION \
  && rm -rf /var/lib/apt/lists/*
RUN set -ex \
  && for path in \
    /usr/share/elasticsearch/data \
    /usr/share/elasticsearch/logs \
    /usr/share/elasticsearch/config \
    /usr/share/elasticsearch/config/scripts \
  ; do \
    mkdir -p "$path"; \
    chown -R elasticsearch:elasticsearch "$path"; \
  done

ADD config/elasticsearch.yml /usr/share/elasticsearch/config/elasticsearch.yml

VOLUME /usr/share/elasticsearch/data
USER elasticsearch
WORKDIR /usr/share/elasticsearch
EXPOSE 9200 9300

ENTRYPOINT ["elasticsearch"]
