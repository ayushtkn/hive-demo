#!/bin/bash
set -e

sudo service docker start || true

docker rm -f hive4 || true

echo "Starting Hive..."
docker run -d \
  -p 10000:10000 \
  -p 10002:10002 \
  --env SERVICE_NAME=hiveserver2 \
  --name hive4 apache/hive:4.2.0

echo "Waiting for Hive..."

until nc -z localhost 10000; do
  sleep 2
done

echo "Hive is ready 🚀"

# Open Beeline in terminal
echo "Launching Beeline..."

# This ensures it runs in Codespaces terminal context
bash -c "docker exec -it hive4 beeline -u 'jdbc:hive2://localhost:10000/'"
