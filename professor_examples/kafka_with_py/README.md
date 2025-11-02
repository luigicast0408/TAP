# Base Kafka Example (Docker CLI Setup)

This guide shows how to start a **Kafka + Zookeeper + Kafka UI + Python Producer & Consumer** stack using **only Docker CLI commands**, without Docker Compose.

---

## Create the Docker network
All containers must share the same network to communicate.

```bash
docker network create kafka-net
```

---

## Start Zookeeper
Zookeeper coordinates Kafka brokers.

```bash
docker run -d \
  --name zookeeper \
  --network kafka-net \
  -p 2181:2181 \
  -e ZOOKEEPER_CLIENT_PORT=2181 \
  -e ZOOKEEPER_TICK_TIME=2000 \
  confluentinc/cp-zookeeper:7.6.1
```

---

## Start Kafka Broker
This starts a single Kafka broker connected to Zookeeper.

```bash
docker run -d \
  --name kafka \
  --network kafka-net \
  -p 9092:9092 \
  -e KAFKA_BROKER_ID=1 \
  -e KAFKA_ZOOKEEPER_CONNECT=zookeeper:2181 \
  -e KAFKA_LISTENERS=PLAINTEXT://0.0.0.0:9092,PLAINTEXT_HOST://0.0.0.0:29092 \
  -e KAFKA_ADVERTISED_LISTENERS=PLAINTEXT://kafka:9092,PLAINTEXT_HOST://localhost:9092 \
  -e KAFKA_LISTENER_SECURITY_PROTOCOL_MAP=PLAINTEXT:PLAINTEXT,PLAINTEXT_HOST:PLAINTEXT \
  -e KAFKA_INTER_BROKER_LISTENER_NAME=PLAINTEXT \
  -e KAFKA_OFFSETS_TOPIC_REPLICATION_FACTOR=1 \
  confluentinc/cp-kafka:7.6.1
```

---

## Start Kafka UI
A web interface to visualize topics, messages, and consumer groups.

```bash
docker run -d \
  --name kafka-ui \
  --network kafka-net \
  -p 8080:8080 \
  -e KAFKA_CLUSTERS_0_NAME=local \
  -e KAFKA_CLUSTERS_0_BOOTSTRAPSERVERS=kafka:9092 \
  -e KAFKA_CLUSTERS_0_ZOOKEEPER=zookeeper:2181 \
  provectuslabs/kafka-ui:latest
```

---

## Run the Python Producer
Make sure you have built the image `tap:python` (from your `python/Dockerfile`).

```bash
docker run --rm \
  --name producer \
  --network kafka-net \
  -v "$(pwd)/script":/usr/src/app \
  -w /usr/src/app \
  tap:python python3 producer.py
```

---

## Run the Python Consumer
In another terminal, run:

```bash
docker run --rm \
  --name consumer \
  --network kafka-net \
  -v "$(pwd)/script":/usr/src/app \
  -w /usr/src/app \
  tap:python python3 consumer.py
```

---

## Verify Connection
Test if Kafka port 9092 is reachable from within the network:

```bash
docker run --rm --network kafka-net busybox nc -zv kafka 9092
```

Expected output:
```
kafka (172.x.x.x:9092) open
```

---

## Stop and Clean Up
When done, stop and remove all containers:

```bash
docker stop kafka kafka-ui zookeeper
docker rm kafka kafka-ui zookeeper
docker network rm kafka-net
```

---