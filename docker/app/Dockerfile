FROM crystallang/crystal:0.26.1

WORKDIR /root
RUN apt-get update
RUN apt-get install -y python
RUN git clone https://github.com/kingsleyh/videom.git
RUN cd videom && shards build
WORKDIR /root/videom/webapp/public

#Ports
EXPOSE 8000

CMD ./server.sh
