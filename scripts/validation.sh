#!/bin/bash
set -e

APP_PORT=5050
HEALTH_URL="http://localhost:${APP_PORT}/login"

echo "Validating application health at $HEALTH_URL"

# Give app some time to start
sleep 10

for i in {1..10}; do
  STATUS_CODE=$(curl -s -o /dev/null -w "%{http_code}" $HEALTH_URL || true)
  if [ "$STATUS_CODE" -eq 200 ]; then
    echo "✅ App is healthy"
    exit 0
  fi
  echo "Waiting for app to be ready... attempt $i"
  sleep 5
done

echo "❌ App failed health check after retries"
exit 1
