#!/bin/bash
docker build -t sentinel-redis:1.3 .
docker tag sentinel-redis:1.3 registry.happycfc.com/test/sentinel-redis:1.3
docker push registry.happycfc.com/test/sentinel-redis:1.3
