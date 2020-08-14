#!/bin/sh

#############################################################################

# Read in properties file

. ./Community/community-release-config.properties

#############################################################################

RELEASE_VERSION="$RELEASE_MAJOR_VERSION.$RELEASE_MINOR_VERSION.$RELEASE_PATCH_VERSION"

### Checkout the release tag - should be created by now, if it fails the script will fail too
set -e
cd ${REPO_DIR}
git fetch ${MASTER_REMOTE}
git checkout payara-server-${RELEASE_VERSION}

# Remove all local docker images and build for jdk8 and jdk11
docker system prune --all
mvn clean install -PBuildDockerImages -pl :docker-images -amd -Dbuild.number=${BUILD_NUMBER}

### Tag images for ${RELEASE_VERSION}
# Server Node
docker tag payara/server-node:${RELEASE_VERSION} payara/server-node:latest

# Server Full
docker tag payara/server-full:${RELEASE_VERSION} payara/server-full:latest

# Server Web
docker tag payara/server-web:${RELEASE_VERSION} payara/server-web:latest

# Micro
docker tag payara/micro:${RELEASE_VERSION} payara/micro:latest

### Push images to docker hub
docker push payara/server-node:latest
docker push payara/server-node:${RELEASE_VERSION}
docker push payara/server-node:${RELEASE_VERSION}-jdk11

docker push payara/server-full:latest
docker push payara/server-full:${RELEASE_VERSION}
docker push payara/server-full:${RELEASE_VERSION}-jdk11

docker push payara/server-web:latest
docker push payara/server-web:${RELEASE_VERSION}
docker push payara/server-web:${RELEASE_VERSION}-jdk11

docker push payara/micro:latest
docker push payara/micro:${RELEASE_VERSION}
docker push payara/micro:${RELEASE_VERSION}-jdk11