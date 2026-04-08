#!/bin/bash

echo "⏳ Waiting for HiveServer2 to fully initialize..."
echo "This usually takes 30-60 seconds on the first run."

# Robust health check loop: Keeps trying to connect until it succeeds
until docker exec hive4 beeline -u 'jdbc:hive2://localhost:10000/' -e "SELECT 1" &> /dev/null; do
  sleep 5
done

echo -e "\n🚀 Hive is ready! Launching Beeline...\n"

# Launch interactive shell
docker exec -it hive4 beeline -u 'jdbc:hive2://localhost:10000/'
