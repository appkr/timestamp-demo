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

# Run schema migration
docker exec -it laravel php /app/artisan migrate

echo ""
echo -e "--------------------------------------------------------------------------------"
echo -e "Testing laravel application"
echo -e "--------------------------------------------------------------------------------"
echo ""

set -x

curl -s -XPOST \
  -H "Content-type: application/json" \
  -H "Accept: application/json" \
  -d '{"body":"test from laravel"}' \
  http://localhost:8080/api/posts; echo ""

set +x

echo ""
echo -e "--------------------------------------------------------------------------------"
echo -e "Testing spring application"
echo -e "--------------------------------------------------------------------------------"
echo ""

set -x

curl -s -XPOST \
  -H "Content-type: application/json" \
  -H "Accept: application/json" \
  -d '{"body":"test from spring"}' \
  http://localhost:8082/api/posts; echo ""

set +x