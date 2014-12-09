#!/bin/bash
# no set -e, we only reload nginx if configuration successful
# and we want nginx to keep running with old configuration
# when we make a mistake

export PATH=/home/curry/.cabal/bin:$PATH
cd /home/curry/app
cabal update
cabal -j4 install --enable-tests --only-dependencies 
cd /home/curry
# watch for changes in and rebuild cabal and run tests
while true; do
  echo "waiting for changes"
  changes=$(inotifywait --exclude=dist -e close_write,moved_to,create /home/curry/app)
  echo $changes
  echo "rebuilding"
  cd /home/curry/app
  cabal -j4 build
  cd /home/curry
  echo rebuilt
done

