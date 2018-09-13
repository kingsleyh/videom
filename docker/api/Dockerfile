FROM crystallang/crystal:0.26.1

WORKDIR /root
RUN apt-get update
RUN git clone https://github.com/kingsleyh/videom.git
RUN cd videom && shards build
WORKDIR /root/videom

#Ports
EXPOSE 3000

CMD bin/videom
