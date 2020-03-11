FROM redis:5.0
#FROM redis:3.0.7

RUN echo "Asia/Shanghai" > /etc/timezone;dpkg-reconfigure -f noninteractive tzdata

RUN apt-get -y update && \
  apt-get install -y --no-install-recommends --no-install-suggests supervisor && \
  rm -rf /var/lib/apt/lists/*

COPY start.sh /
COPY redis-7000.conf /
COPY redis-7001.conf /
COPY sentinel-8000.conf /data
COPY sentinel-8001.conf /data
COPY sentinel-8002.conf /data

RUN chmod 666 /redis-7001.conf /redis-7000.conf /data/sentinel-8000.conf /data/sentinel-8001.conf /data/sentinel-8002.conf
RUN chmod 555 /start.sh

VOLUME /var/redis/log
WORKDIR /data

EXPOSE 7000 7001 8000 8001 8002

ENTRYPOINT ["/start.sh"]
