#!/bin/bash

apt update
apt install -y docker.io
docker run eranzaksh/infinity:actions
