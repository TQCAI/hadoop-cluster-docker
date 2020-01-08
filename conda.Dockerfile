FROM tqc/hadoop:2.0

MAINTAINER qichun.tang@xtalpi.com

ADD Miniconda3-latest-Linux-x86_64.sh /root/Miniconda3-latest-Linux-x86_64.sh
ADD python-config/passwd.exp /root/passwd.exp 
ADD python-config/passwd.py /root/passwd.py 
ADD python-config/pip.conf /root/.pip/pip.conf
ADD env.Dockerfile /tmp/env.Dockerfile

WORKDIR /root

RUN chmod a+x Miniconda3-latest-Linux-x86_64.sh \
    && bash Miniconda3-latest-Linux-x86_64.sh  -b -p $HOME/miniconda3 \
    && $HOME/miniconda3/bin/conda init \
    && . ~/.bashrc \
    && conda install python=3.6.8 \
    && rm Miniconda3-latest-Linux-x86_64.sh  \
    && conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/free/  \
    && conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/conda-forge \
    && conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/msys2/ \
    && conda config --set show_channel_urls yes \
    && pip install ipython && pip install jupyter \
    && mkdir -p /root/workspace \
    && apt install expect -y \
    && jupyter notebook --generate-config \
    && JWD=`expect passwd.exp |sed -n '$p'` \
    && JWD=${JWD%?} \
    && rm passwd.* \
    && mv /root/.jupyter/jupyter_notebook_config.py /root/.jupyter/jupyter_notebook_config.py.bak \
    && sed -e "s/#c.NotebookApp.password = ''/c.NotebookApp.password = \"$JWD\"/" /root/.jupyter/jupyter_notebook_config.py.bak > /root/.jupyter/jupyter_notebook_config.py \
    && sed -e "s/ENV/export/" /tmp/env.Dockerfile >> /root/.profile 

RUN git clone git@github.com:TQCAI/pyspark_study.git \
    && apt install net-tools 
# export PYSPARK_DRIVER_PYTHON_OPTS="-m jupyter notebook --ip 0.0.0.0 --allow-root --no-browser -y"



CMD [ "bash", "-c", "service ssh start;source /root/miniconda3/bin/activate; bash"]
# ENTRYPOINT [ "bash", "-c", "service ssh start;source /root/miniconda3/bin/activate;"]
# auto add env
ENV SCALA_HOME=/usr/share/scala
ENV HADOOP_CONF_DIR=/usr/local/hadoop/etc/hadoop
ENV SPARK_HOME=/usr/local/spark
ENV PATH=$PATH:/usr/local/spark/bin
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64 
ENV HADOOP_HOME=/usr/local/hadoop 
ENV PATH=$PATH:/usr/local/hadoop/bin:/usr/local/hadoop/sbin 
ENV PYSPARK_DRIVER_PYTHON="/root/miniconda3/bin/python"
ENV PYSPARK_PYTHON="/root/miniconda3/bin/python"
ENV PYTHONPATH=$PYTHONPATH:$SPARK_HOME/python
ENV PYTHONPATH=$PYTHONPATH:$SPARK_HOME/python/lib/py4j-0.10.8.1-src.zip