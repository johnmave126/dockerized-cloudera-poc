FROM centos:7
ENV container docker
RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == \
systemd-tmpfiles-setup.service ] || rm -f $i; done); \
rm -f /lib/systemd/system/multi-user.target.wants/*;\
rm -f /etc/systemd/system/*.wants/*;\
rm -f /lib/systemd/system/local-fs.target.wants/*; \
rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
rm -f /lib/systemd/system/basic.target.wants/*;\
rm -f /lib/systemd/system/anaconda.target.wants/*;
VOLUME [ "/sys/fs/cgroup" ]

RUN yum -y update; yum clean all
RUN yum -y install openssh-server openssh-clients bind-utils which sudo passwd net-tools python curl wget ntp python27; yum clean all
RUN systemctl enable sshd.service
RUN passwd -d root

ADD https://github.com/ufoscout/docker-compose-wait/releases/download/2.7.3/wait /wait
RUN chmod +x /wait

RUN mkdir -p /root/.ssh && \
    chmod 700 /root/.ssh && \
    touch /root/.ssh/authorized_keys && \
    chmod 600 /root/.ssh/authorized_keys

ADD https://archive.cloudera.com/cm6/6.3.1/redhat7/yum/cloudera-manager.repo /etc/yum.repos.d/cloudera-manager.repo

RUN yum update -y; yum install -y oracle-j2sdk1.8
RUN yum install -y cloudera-manager-agent cloudera-manager-daemons

RUN wget -P /tmp https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-5.1.48.tar.gz && \
    tar -C /tmp -xvf /tmp/mysql-connector-java-5.1.48.tar.gz && \
    mkdir -p /usr/share/java && \
    cp /tmp/mysql-connector-java-5.1.48/mysql-connector-java-5.1.48-bin.jar /usr/share/java/mysql-connector-java.jar && \
    rm -rf /tmp/mysql-connector-java-5.1.48 /tmp/mysql-connector-java-5.1.48.tar.gz

COPY start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 22 9000 9001 21000

VOLUME ["/var/log", "/run"]

ENTRYPOINT ["/start.sh"]
CMD ["/usr/sbin/init"]
