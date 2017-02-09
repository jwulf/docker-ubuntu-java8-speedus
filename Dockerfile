FROM ubuntu:14.04

MAINTAINER Josh Wulf "josh@magikcraft.io"

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update -y && \
    apt-get install -y software-properties-common && \ 
    apt-add-repository ppa:webupd8team/java && \
    apt-get update -y && \
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EEA14886 && \
    echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections && \
    apt-get install -y oracle-java8-installer && \
    apt-get install -y oracle-java8-unlimited-jce-policy && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /var/cache/oracle-jdk8-installer

ENV JAVA_HOME /usr/lib/jvm/java-8-oracle

ENV TERM=xterm
ENV TZ=Australia/Brisbane

ENV speedus_dir /opt/torusware/speedus
ENV netpipe_dir $speedus_dir/benchmarks/NetPIPE-C

RUN apt-get clean && apt-get update \
 && apt-get -qqy install wget unzip make gcc \
    nano build-essential \
    libsdl2-dev libsdl2-ttf-dev libpango1.0-dev \
    libgl1-mesa-dev libopenal-dev libsndfile-dev awscli \
 && apt-get -qqy install ruby-dev \
 && gem install gosu \
 && rm -rf /var/lib/apt/lists/*

# START Speedus
WORKDIR /opt
RUN mkdir torusware \
 && cd torusware \
 && wget http://dl.torusware.com/speedus/release/speedus-latest-linux.zip \
 && unzip speedus-latest-linux.zip \
 && rm speedus-latest-linux.zip \
 && ln -s speedus-b* speedus \
 && cp speedus/doc/README.image.txt $root_home/SPEEDUS_README.txt

WORKDIR /root
ADD speedus /usr/bin/speedus

WORKDIR $netpipe_dir
RUN make
RUN cp NPtcp /usr/bin/NPtcp
# END Speedus

