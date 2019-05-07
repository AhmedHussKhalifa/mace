#!/bin/bash

set -e

BUILD_DIR_NAME="docker"
CURRENT_DIR_NAME=`basename "$PWD"`

if [ $BUILD_DIR_NAME != $CURRENT_DIR_NAME ]; then
  echo "You can run script only in 'mace/docker' directory"
  exit 1
fi

# build images
docker build -t registry.cn-hangzhou.aliyuncs.com/xiaomimace/mace-dev-lite ./mace-dev-lite || exit 1
docker build -t registry.cn-hangzhou.aliyuncs.com/xiaomimace/mace-dev ./mace-dev-lite || exit 1
docker build -t registry.cn-hangzhou.aliyuncs.com/xiaomimace/gitlab-runner ./gitlab-runner || exit 1

if grep -lq registry.cn-hangzhou.aliyuncs.com ~/.docker/config.json; then
  # update images to repository
  docker push registry.cn-hangzhou.aliyuncs.com/xiaomimace/mace-dev-lite || exit 1
  docker push registry.cn-hangzhou.aliyuncs.com/xiaomimace/mace-dev || exit 1
  docker push registry.cn-hangzhou.aliyuncs.com/xiaomimace/gitlab-runner || exit 1
else
  echo "Login docker registry server is needed!"
  exit 1
fi
