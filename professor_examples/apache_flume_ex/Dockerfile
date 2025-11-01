# ==========================
#  Apache Flume (Netcat -> Logger)
#  Compatibile Mac M1–M4 (ARM64)
# ==========================

FROM arm64v8/eclipse-temurin:8-jdk-jammy
LABEL maintainer="luigidomenicocastano"

ENV FLUME_VERSION=1.11.0 \
    FLUME_HOME=/opt/flume \
    PATH=/opt/flume/bin:$PATH

# Install utility di base
RUN apt-get update && apt-get install -y net-tools curl bash && rm -rf /var/lib/apt/lists/*

# Copia Flume
ADD pkg/apache-flume-${FLUME_VERSION}-bin.tar.gz /opt/
RUN ln -s /opt/apache-flume-${FLUME_VERSION}-bin /opt/flume

# Copia configurazioni
ADD conf/ /opt/flume/conf/

# Copia script di avvio
COPY start-flume.sh /opt/flume/bin/start-flume
RUN chmod +x /opt/flume/bin/start-flume

EXPOSE 44444

ENV FLUME_AGENT_NAME=a1 \
    FLUME_CONF_FILE=example.conf

ENTRYPOINT ["/opt/flume/bin/start-flume"]