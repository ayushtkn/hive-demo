#!/bin/bash
set -e

sudo service docker start || true

# Remove old container if it exists
docker rm -f hive4 || true

echo "Starting Hive container..."
docker run -d \
  -p 10000:10000 \
  -p 10002:10002 \
  --env SERVICE_NAME=hiveserver2 \
  --name hive4 apache/hive:4.2.0
