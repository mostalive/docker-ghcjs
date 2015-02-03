#!/bin/bash

export DEV_UID=`id -u`
export DEV_GID=`id -g`
export DOCKER_GID=`getent group docker | cut -d: -f3`
echo $DOCKER_GID
echo $UID
echo $GID
docker rm -f ghcjs-emacs 
docker run --name ghcjs-emacs -u root -it -e DEV_UID=$DEV_UID -e DEV_GID=$DEV_GID -e DOCKER_GID=$DOCKER_GID -P -v /var/run/docker.sock:/var/run/docker.sock -v $(pwd)/..:/home/curry/capital-match atddio/ghcjs-emacs /home/curry/matchuidgids.sh
