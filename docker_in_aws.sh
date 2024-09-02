#!/bin/bash

apt update
apt install -y docker.io
docker run -p 8000:8000 -d eranzaksh/infinity:small-app
