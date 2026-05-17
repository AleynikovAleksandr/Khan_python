FROM apache/spark:latest

LABEL org.opencontainers.image.authors="Apache Spark project <dev@spark.apache.org>"
LABEL org.opencontainers.image.licenses="Apache-2.0"
LABEL org.opencontainers.image.ref.name="Apache Spark Scala/Java Image"
LABEL org.opencontainers.image.version="4.2.0-preview5"

USER root

ARG spark_uid=185

RUN set -ex && \
    apt-get update && \
    ln -s /lib /lib64 && \
    apt-get install -y --no-install-recommends \
      bash \
      tini \
      libc6 \
      libpam-modules \
      krb5-user \
      libnss3 \
      procps \
      net-tools \
      logrotate \
      libssl-dev \
      curl \
      wget \
      rsync \
      openssh-client \
      python3 \
      python3-pip \
      python3-dev && \
      \
    mkdir -p /usr/share/keyrings && \
    wget -O - https://repos.azul.com/azul-repo.key | gpg --dearmor -o /usr/share/keyrings/azul.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/azul.gpg] https://repos.azul.com/zulu/deb stable main" \
      > /etc/apt/sources.list.d/zulu.list && \
    apt-get update && \
    apt-get install -y zulu21-jdk && \
    \
    mkdir -p /opt/spark && \
    mkdir -p /opt/spark/examples && \
    mkdir -p /opt/spark/work-dir && \
    mkdir -p /opt/spark/events && \
    mkdir -p /opt/spark/logs_root && \
    mkdir -p /opt/spark/data && \
    mkdir -p /opt/spark/apps && \
    touch /opt/spark/RELEASE && \
    rm /bin/sh && \
    ln -sv /bin/bash /bin/sh && \
    echo "auth required pam_wheel.so use_uid" >> /etc/pam.d/su && \
    chgrp root /etc/passwd && \
    chmod ug+rw /etc/passwd && \
    apt-get clean && \
    rm -rf /var/cache/apt/* /var/lib/apt/lists/*


ENV SPARK_HOME=/opt/spark

ENV JAVA_HOME=/usr/lib/jvm/zulu21
ENV PATH="${JAVA_HOME}/bin:${PATH}"

RUN pip3 install --no-cache-dir \
    pandas \
    pyarrow \
    numpy 

    
COPY decom.sh /opt/decom.sh
RUN chmod a+x /opt/decom.sh

RUN chown -R ${spark_uid}:0 /opt/spark && \
    chmod -R 775 /opt/spark && \
    chmod a+x /opt/decom.sh

WORKDIR /opt/spark/work-dir

ENTRYPOINT ["/opt/entrypoint.sh"]

USER ${spark_uid}