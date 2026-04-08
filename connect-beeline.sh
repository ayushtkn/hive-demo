#!/bin/bash

# 1. Start Docker (Linux only, ignores harmlessly on Mac)
sudo service docker start 2>/dev/null || true

# 2. Start container if not running
if ! docker ps --format '{{.Names}}' | grep -Eq "^hive4\$"; then
    echo "📦 Starting Hive container..."
    docker rm -f hive4 2>/dev/null || true
    
    docker run -d \
      -p 10000:10000 \
      -p 10002:10002 \
      --env SERVICE_NAME=hiveserver2 \
      --name hive4 apache/hive:4.2.0
fi

echo -n "⏳ Waiting for HiveServer2 to fully initialize (takes 45-60s)"

# 3. Robust health check loop
# It tries to connect. If it fails, it prints a dot, sleeps 10s, and tries again.
until docker exec -it  hive4 beeline -n root -u 'jdbc:hive2://localhost:10000/' -e "SELECT 1;" &> /dev/null; do
  echo -n "."
  sleep 10
done

echo -e "\n\n🚀 Hive is ready! Launching Beeline...\n"

# 4. Launch interactive shell
docker exec -it hive4 beeline -u 'jdbc:hive2://localhost:10000/'
