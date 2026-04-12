FROM apache/hadoop:3.4.3

USER root

# Java + SSH
RUN apt-get update && apt-get install -y \
 openjdk-11-jdk \
 openssh-server \
 nano \
 curl \
 && apt-get clean

 RUN mkdir -p /var/run/sshd

ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
ENV PATH=$PATH:$JAVA_HOME/bin

COPY bootstrap.sh /bootstrap.sh
RUN chmod +x /bootstrap.sh

CMD ["/bootstrap.sh"]