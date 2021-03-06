#Build the haproxy container, add php, run a custom script to make it automagical
FROM haproxy
MAINTAINER kc merrill <kcmerrill@gmail.com>

RUN apt-get -y update
RUN apt-get -y install php5 curl

ADD . /automagicproxy
COPY bin/config/haproxy.cfg /etc/haproxy/haproxy.cfg
ENTRYPOINT haproxy -f /etc/haproxy/haproxy.cfg -D -p /var/run/haproxy.pid && \
/automagicproxy/bin/reload && \
while ps aux | egrep -v "USER|PID|CPU" | grep haproxy ; do /automagicproxy/bin/reload > /dev/null && sleep 5; done
