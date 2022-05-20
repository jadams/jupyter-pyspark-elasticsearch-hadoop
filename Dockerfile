FROM public.ecr.aws/j1r0q0g6/notebooks/notebook-servers/jupyter:master-434b10ab

USER root
ENV SCALAVER 2.12.15
RUN export DEBIAN_FRONTEND=noninteractive \
 && apt-get -yq update \
 && apt-get -yq install --no-install-recommends \
    openjdk-8-jdk \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*
USER $NB_UID

COPY --chown=jovyan:users requirements.txt /tmp/requirements.txt
RUN python3 -m pip install -r /tmp/requirements.txt --quiet --no-cache-dir \
 && rm -f /tmp/requirements.txt

ENV ESHADOOPVER 7.16.3
RUN curl -sL "https://artifacts.elastic.co/downloads/elasticsearch-hadoop/elasticsearch-hadoop-${ESHADOOPVER}.zip" -o /tmp/elasticsearch-hadoop-${ESHADOOPVER}.zip \
 && unzip /tmp/elasticsearch-hadoop-${ESHADOOPVER}.zip -d /tmp \
 && cp /tmp/elasticsearch-hadoop-${ESHADOOPVER}/dist/elasticsearch-hadoop-${ESHADOOPVER}.jar /opt/conda/lib/python3.8/site-packages/pyspark/jars \
 && rm -rf /tmp/elasticsearch-hadoop-${ESHADOOPVER}.zip /tmp/elasticsearch-hadoop-${ESHADOOPVER}
