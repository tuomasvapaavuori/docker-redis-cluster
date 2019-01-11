# set base image
FROM redis:3.0.6

ENV REDIS_PORT_LIST "7005,7006,7007,7008,7009,7010"
# install dependencies
RUN apt-get update
RUN apt-get install -y \
    openssl \
    wget \
    ruby-full \
    supervisor
RUN gem install redis -v 3.0.6
# set workdir
WORKDIR /workdir
# get redis-trib.rb used for managing cluster
RUN wget https://raw.githubusercontent.com/antirez/redis/3d61cb0cb18a34bc537f5b4b98adb963a6911923/src/redis-trib.rb
RUN chmod a+rx redis-trib.rb
# copy supervisor config
COPY init.sh /opt/redis-cluster/init.sh
# run multiple redis instances using supervisord 
# use sleep to wait for supervisord (running as daemon) spawn all process
# make all spawned process as redis cluster
# use tail to keep container open
CMD ["/opt/redis-cluster/init.sh"]
