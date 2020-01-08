FROM tqc/hadoop:1.0

MAINTAINER qichun.tang@xtalpi.com

ADD spark-3.0.0-preview2-bin-hadoop3.2 /usr/local/spark-3.0.0-preview2-bin-hadoop3.2 
ADD env.Dockerfile /tmp/env.Dockerfile
ADD scala-2.13.0.deb /tmp/scala-2.13.0.deb

RUN dpkg -i /tmp/scala-2.13.0.deb && rm /tmp/scala-2.13.0.deb && \
    ln -sf /usr/local/spark-3.0.0-preview2-bin-hadoop3.2   /usr/local/spark && \
    sed -e "s/ENV/export/" /tmp/env.Dockerfile >> /root/.profile 

# auto add env
ENV SCALA_HOME=/usr/share/scala
ENV HADOOP_CONF_DIR=/usr/local/hadoop/etc/hadoop
ENV SPARK_HOME=/usr/local/spark
ENV PATH=$PATH:/usr/local/spark/bin
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64 
ENV HADOOP_HOME=/usr/local/hadoop 
ENV PATH=$PATH:/usr/local/hadoop/bin:/usr/local/hadoop/sbin 