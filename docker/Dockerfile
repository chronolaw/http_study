# Dockerfile
# chrono@2020-08

# curl -fsSL https://get.docker.com | bash -s docker --mirror Aliyun
# sudo service docker start
# sudo usermod -aG docker ${USER}

# docker image build -t chronolaw/http_study .

# docker run -it chronolaw/http_study bash
# docker run -it --rm --net=host chronolaw/http_study bash
# docker run -it --rm chronolaw/http_study bash

# you can use unix socket in docker, just with '-v'
# docker run -it --rm  -v /tmp:/tmp chronolaw/http_study

# docker run -it --add-host=www.chrono.com:127.0.0.1 chronolaw/http_study bash
# docker run -it --add-host=www.chrono.com:127.0.0.1 --add-host=www.metroid.net:127.0.0.1 --rm chronolaw/http_study bash

# docker exec -it container_id bash

# docker login
# docker image push chronolaw/http_study
# docker image pull chronolaw/http_study


# cat ~/http_study/hosts >> /etc/hosts
# cd ~/http_study/www
# ./run.sh start

# telnet 127.0.0.1 80
# telnet www.chrono.com 80

# curl 127.0.0.1 -v
# curl http://www.chrono.com/07-1 -v

# https
# curl https://www.chrono.com/23-1 -vk --tlsv1.2
# curl https://www.chrono.com/23-1 -vk

# http/2
# curl https://www.chrono.com/30-1 -vk
# curl https://www.metroid.net:8443/11-1 -vk
# curl https://www.metroid.net:8443/30-1 -vk

# tcpdump tcp port 80 -i lo -w /tmp/a.pcap
# curl http://www.chrono.com/07-1 -v
# tcpdump tcp port 443 -i lo -w /tmp/a.pcap
# SSLKEYLOGFILE=/tmp/a.log curl https://www.chrono.com/11-1 -vk
# docker cp container_id:/tmp/a.pcap .

#ARG RESTY_IMAGE="openresty/openresty:bionic"
ARG RESTY_IMAGE="openresty/openresty:1.17.8.2-5-bionic"

FROM ${RESTY_IMAGE}

ARG NGX_CONF="./http_study/www/conf/nginx.conf"
#ARG HOSTS="/etc/hosts"

#LABEL version="2020-08"
#LABEL resty_version="1.17.8.2"

RUN DEBIAN_FRONTEND=noninteractive apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        sudo vim git tcpdump telnet\
    && cd \
    && git clone https://github.com/chronolaw/http_study --depth=1 \
    && sed -i 's/^#user root/user root/g' ${NGX_CONF} \
    && DEBIAN_FRONTEND=noninteractive apt-get autoremove -y


# http service
EXPOSE 80 8080

# https/http2 service
EXPOSE 440 441 442 443 8443

CMD ["/bin/bash"]
#CMD ["/bin/bash", "-c", "cat /root/http_study/hosts >> /etc/hosts;cd /root/http_study/www;./run.sh start"]
