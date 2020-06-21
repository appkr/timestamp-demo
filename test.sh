#!/usr/bin/env bash

while true; do
  rt=$(nc -z -w 1 127.0.0.1 3306)
  if [ $? -eq 0 ]; then
    echo "DB is UP"
    break
  fi
  echo "DB is not yet reachable;sleep for 10s before retry"
  sleep 10
done

curl -s -XPOST \
  -H "Content-type: application/json" \
  -H "Accept: application/json" \
  -d '{"body":"test"}' \
  http://localhost:8080/api/posts

echo ""