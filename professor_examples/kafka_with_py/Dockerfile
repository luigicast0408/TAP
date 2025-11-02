FROM python:3.13

WORKDIR /usr/src/app

COPY requirements.txt ./


RUN pip install --no-cache-dir -r requirements.txt || echo "skip"

COPY start-kafka.sh /usr/src/app/start-kafka.sh

COPY script/ /usr/src/app/script/

RUN chmod +x /usr/src/app/start-kafka.sh

ENTRYPOINT ["/usr/src/app/start-kafka.sh"]
