#!/usr/bin/env bash

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
NC='\033[0m'

ensure_dependency() {
  if ! which "$1" &>/dev/null ; then
    echo "$1 not found"
    exit 1
  fi
}

ensure_regex() {
  local command="$1"
  local requirement="$2"
  local cmd_output=`$1 | head -n 1`
  if [[ ! "$cmd_output" =~ "$requirement" ]]; then
    echo "$cmd_output does not contains $requirement"
    exit 1
  fi
}

ensure_dependency php
# ensure_regex "php -v" "7.4"
ensure_dependency docker
ensure_dependency docker-compose
ensure_dependency gsed # brew install gnu-sed
# ensure_dependency java

cd laravel; CWD=$(pwd)
echo -e "${YELLOW}Current working directory is ${CWD}${NC}"
echo -e "--------------------------------------------------------------------------------"

set -x

cp .env.example .env
gsed -i "s/APP_TIMEZONE=.*/APP_TIMEZONE=Asia\/Seoul/" .env
gsed -i "s/DB_HOST=.*/DB_HOST=mysql/" .env
gsed -i "s/DB_DATABASE=.*/DB_DATABASE=timestamp_demo/" .env
gsed -i "s/DB_USERNAME=.*/DB_USERNAME=homestead/" .env
gsed -i "s/DB_PASSWORD=.*/DB_PASSWORD=secret/" .env

php ./composer.phar install
php ./artisan key:generate

set +x

cd ..; CWD=$(pwd)
echo -e "${YELLOW}Current working directory is ${CWD}${NC}"
echo -e "--------------------------------------------------------------------------------"

set -x

docker-compose up

set +x

# docker-compse down
