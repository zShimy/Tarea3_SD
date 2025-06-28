FROM openjdk:8-jre

RUN apt-get update && \
    apt-get install -y wget tar && \
    wget https://downloads.apache.org/pig/pig-0.17.0/pig-0.17.0.tar.gz && \
    tar -xzf pig-0.17.0.tar.gz -C /opt && \
    rm pig-0.17.0.tar.gz

ENV PIG_HOME=/opt/pig-0.17.0
ENV PATH="$PATH:$PIG_HOME/bin"

WORKDIR /app

COPY process_events.pig /app/process_events.pig

CMD ["pig", "-x", "local", "/app/process_events.pig"]

