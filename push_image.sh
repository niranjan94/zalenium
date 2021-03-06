#!/usr/bin/env bash

# Exit on failure
set -e

# Push docker image when a tag is set and it is the master branch.
# The tag will be set locally in one of the developer's machine.

echo "TRAVIS_TAG=${TRAVIS_TAG}"

cat scm-source.json

if [ "$TRAVIS_PULL_REQUEST" = "false" ] && [ -n "${TRAVIS_TAG}" ] && [ "${TRAVIS_TAG}" != "latest" ]; then
	echo "Building image..."
	mvn clean package -Pbuild-docker-image -DskipTests=true
	echo "Starting to push Zalenium image..."
	docker login -u="$DOCKER_USERNAME" -p="$DOCKER_PASSWORD"
    echo "Logged in to docker."
    echo "docker tag and docker push using TRAVIS_TAG=${TRAVIS_TAG}"
    docker tag zalenium:latest niranjan94/zalenium:${TRAVIS_TAG}
    docker tag zalenium:latest niranjan94/zalenium:3
    docker tag zalenium:latest niranjan94/zalenium:latest
    docker push niranjan94/zalenium
else
	echo "Image not being pushed, either this is a PR, no tag is set, or the branch is not master."
fi