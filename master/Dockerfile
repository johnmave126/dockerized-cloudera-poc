FROM ubuntu:18.04

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y wget && rm -rf /var/lib/apt/lists/*

RUN wget -q -nv -P /tmp http://ftp.us.debian.org/debian/pool/main/n/netselect/netselect_0.3.ds1-28+b1_amd64.deb && \
    dpkg -i /tmp/netselect_0.3.ds1-28+b1_amd64.deb && \
    rm -rf /tmp/netselect_0.3.ds1-28+b1_amd64.deb

RUN netselect -s 1 -t 20 `wget -qO - http://mirrors.ubuntu.com/mirrors.txt` 2>/dev/null \
    | awk '{ print $2 }' \
    | xargs -i sed -i "s#http://archive.ubuntu.com/ubuntu/#{}#g" /etc/apt/sources.list

RUN apt-get update && \
    apt-get install -y sudo gnupg-agent apt-transport-https ca-certificates curl software-properties-common openjdk-11-jdk libmysql-java python-minimal && \
    apt-get clean

RUN ln -s /usr/lib/jvm/java-11-openjdk-amd64 /usr/lib/jvm/jdk-11
ENV JAVA_HOME /usr/lib/jvm/jdk-11

RUN curl -fsSL https://archive.cloudera.com/cm6/6.3.1/ubuntu1804/apt/archive.key | apt-key add - && \
    add-apt-repository "deb [arch=amd64] http://archive.cloudera.com/cm6/6.3.1/ubuntu1804/apt bionic-cm6.3.1 contrib" && \
    apt-get update && \
    apt-get install -y cloudera-manager-daemons cloudera-manager-agent cloudera-manager-server && \
    apt-get clean

RUN mkdir -p /opt/cloudera/parcel-repo && \
    wget -nv --show-progress --progress=bar:force:noscroll -P /opt/cloudera/parcel-repo https://archive.cloudera.com/cdh6/6.3.2/parcels/CDH-6.3.2-1.cdh6.3.2.p0.1605554-el7.parcel &&\
    wget -nv --show-progress --progress=bar:force:noscroll -O /opt/cloudera/parcel-repo/CDH-6.3.2-1.cdh6.3.2.p0.1605554-el7.parcel.sha https://archive.cloudera.com/cdh6/6.3.2/parcels/CDH-6.3.2-1.cdh6.3.2.p0.1605554-el7.parcel.sha1 && \
    wget -nv --show-progress --progress=bar:force:noscroll -P /opt/cloudera/parcel-repo https://archive.cloudera.com/cdh6/6.3.2/parcels/manifest.json && \
    chown -R cloudera-scm:cloudera-scm /opt/cloudera/parcel-repo/*

COPY start.sh /
RUN chmod +x /start.sh

ADD https://github.com/ufoscout/docker-compose-wait/releases/download/2.7.3/wait /wait
RUN chmod +x /wait

EXPOSE 7180 7183 7187


ENTRYPOINT ["/start.sh"]

