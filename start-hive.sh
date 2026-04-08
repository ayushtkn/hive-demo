#!/bin/bash
set -e

# Start docker if needed
sudo service docker start || true

# Remove old container if exists
docker rm -f hive4 || true

echo "Starting Hive..."
docker run -d \
  -p 10000:10000 \
  -p 10002:10002 \
  --env SERVICE_NAME=hiveserver2 \
  --name hive4 apache/hive:4.2.0

echo "Waiting for Hive to be ready..."

# Wait until port is open
until nc -z localhost 10000; do
  sleep 2
done

echo "Hive is ready!"

echo ""
echo "👉 Run this to start Beeline:"
echo "docker exec -it hive4 beeline -u 'jdbc:hive2://localhost:10000/'"
