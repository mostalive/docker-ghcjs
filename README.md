Docker-ghcjs
============

Head over to  [ghcjs](https://github.com/ghcjs/ghcjs) for the latest
official version of the Dockerfile to build ghcjs.

This repository is used to experiment with docker files for ghcjs, the haskell to javascript compiler [ghcjs](https://github.com/ghcjs/ghcjs), as
minimal as possible against the latest ghcjs, built from the
[ghjcs installation instructions](https://github.com/ghcjs/ghcjs). Based on standard haskell:7.8 container
with alex and happy. 

You can use this container to play around with ghcjs, or use it as a
source to build a more specific image in a FROM chain.

# Running

Download from dockerhub and run in one go

```
docker run -i -t atddio/docker-ghcjs
```

For compiling against a directory on the host machine, run it with -v,
see [Docker
volumes](https://docs.docker.com/userguide/dockervolumes/) for
instructions.

# Building

```
docker build .
```

# Background
Unlike https://github.com/rvl/ghcjs-docker, which uses git submodules I chose to download the
relevant ghcjs git repositories in the Docker file, so whenever you run
docker build you can get the latest versions. As long as the
installation instructions don't change this should work. 

That repository, on the
upside, has a normal user instead of the root user. So far, for
building things I haven't found much of an upside for adding a regular
users. for running a service perhaps. YMMV.

Suggestions and pull requests welcome. Happy hacking!
