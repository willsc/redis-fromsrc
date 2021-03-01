FROM ubuntu:18.04
RUN apt-get -y update \
  && apt-get -y upgrade \
  && apt-get -y --no-install-recommends install bash ruby apt-utils build-essential wget 

RUN apt-get install -y rubygems
RUN wget http://download.redis.io/releases/redis-5.0.9.tar.gz
RUN  tar zxvf redis-5.0.9.tar.gz && \
cd redis-5.0.9 && \
make && \
make install && \
cp -f src/redis-* /usr/local/bin/ && \
mkdir -p /etc/redis && \
cp -f *.conf /etc/redis && \
rm -rf /tmp/redis-stable* && \
sed -i 's/^\(bind .*\)$/# \1/' /etc/redis/redis.conf && \
sed -i 's/^\(daemonize .*\)$/# \1/' /etc/redis/redis.conf && \
sed -i 's/^\(dir .*\)$/# \1\ndir \/data/' /etc/redis/redis.conf && \
sed -i 's/^\(logfile .*\)$/# \1/' /etc/redis/redis.conf



RUN useradd -r -s /bin/false redis
RUN touch /var/run/redis.pid
RUN chown redis:redis /var/run/redis.pid
COPY redis.service /etc/systemd/system/

 

COPY redis.conf /usr/local/etc/redis/redis.conf
CMD [ "redis-server", "/usr/local/etc/redis/redis.conf" ]
EXPOSE 6379
