#!/bin/sh
curl -H "Content-Type: application/json" -X POST \
  --data "{\"source_type\": \"Tag\", \"source_name\": \"$TRAVIS_TAG\"}" \
  https://registry.hub.docker.com/u/vartan/anvil-connect/trigger/$DOCKER_TRIGGER_TOKEN/
