# 🐳 Apache Flume – Minimal Docker Setup Guide

A concise step-by-step guide to build, run, and test **Apache Flume** inside Docker with a simple **Netcat → Logger** pipeline.

---

## ⚙️ 1. Create the Docker Network *(only once)*
```bash
docker network create --subnet=10.0.100.0/24 tap
```
## Download Required Packages
```bash
cd ../ 
bash runme.sh 
cd ..
```

##  Build the Docker Image
```bash
docker build . --tag tap:flume
```
## 🚀 2. Run the Apache Flume Container
```bash
docker run --rm --name flumehw \
  --network tap \
  --ip 10.0.100.10 \
  -p 44444:44444 \
  -e FLUME_CONF_FILE=example.conf \
  tap:flume

```
## View Flume Logs
In another terminal, you can view the Flume logs to monitor activity:
```bash
docker exec -it flumehw tail -f flume.log
```

## Test with Netcat
In another terminal, use `netcat` to send test data to the Flume agent:
```bash
nc localhost 44444
```

Type any text and press Enter. You should see the text being logged by Flume.
