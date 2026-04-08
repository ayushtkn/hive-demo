#!/bin/bash

# 1. Start Docker service if it's not already awake
sudo service docker start || true

# 2. Check if the hive4 container is already running. If not, start it!
if ! docker ps --format '{{.Names}}' | grep -Eq "^hive4\$"; then
    echo "📦 Starting Hive container..."
    # Clean up any broken/exited containers first
    docker rm -f hive4 2>/dev/null || true
    
    # Start the container
    docker run -d \
      -p 10000:10000 \
      -p 10002:10002 \
      --env SERVICE_NAME=hiveserver2 \
      --name hive4 apache/hive:4.2.0
fi

echo "⏳ Waiting for HiveServer2 to fully initialize..."
echo "This usually takes 30-60 seconds on the first run."

# 3. Robust health check loop: Keeps trying to connect until it succeeds
until docker exec hive4 beeline -u 'jdbc:hive2://localhost:10000/' -e "SELECT 1" &> /dev/null; do
  sleep 5
done

echo -e "\n🚀 Hive is ready! Launching Beeline...\n"

# 4. Launch interactive shell
docker exec -it hive4 beeline -u 'jdbc:hive2://localhost:10000/'
