#!/bin/bash

PROJECT_DIR="$(cd "$(dirname "$0")" && pwd)"
CONF_DIR="$PROJECT_DIR/conf"
LOG_DIR="$PROJECT_DIR/logs"
CONTAINER_NAME="fluentd"
IMAGE_NAME="fluent/fluentd:v1.17-debian"

mkdir -p "$LOG_DIR"

echo "1) Start Fluentd..."
echo "2) Configuration directory: $CONF_DIR"
echo "3) Docker image: $IMAGE_NAME"
echo "4) Port: 9880"

if [ "$(docker ps -aq -f name=^$CONTAINER_NAME$)" ]; then
  echo "Found existing Fluentd container. Removing..."
  docker rm -f "$CONTAINER_NAME" >/dev/null 2>&1
fi


docker run --rm \
  --hostname "$CONTAINER_NAME" \
  --name "$CONTAINER_NAME" \
  -p 9880:9880 \
  -v "$CONF_DIR:/fluentd/etc" \
  -v "$LOG_DIR:/fluentd/logs" \
  "$IMAGE_NAME" \
  -c /fluentd/etc/fluent.conf

echo "Fluentd container terminated."
