Docker-ghcjs
============

This repository contains a number of Docker files to build images for ghcjs,
libraries to use with ghjcs (e.g. canvas or virtual-dom) and an
auto-recompiling development environment. I'm trying to combine the best
of javascript (fast feedback on changes to a browser UI) with the best
of haskell
(mistake-proofing through type safety, a great set of libraries, and
wonderful testing tools such as quickcheck).

This repository is experimental, have fun at your own risk.

# Building

On your host machine:

```
cabal install shake
./build.sh
```

This takes a while, and will build the full chain of images, based on
the standard haskell:7.8 docker image.

# Running

on a ubuntu host, in your projects' directory, run

```
docker run -it -v $(pwd):/home/curry/app atddio/ghcjs-sample-devenv
``` 


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

Head over to  [ghcjs](https://github.com/ghcjs/ghcjs) for the latest
official version of the Dockerfile to build ghcjs.

This repository is used to experiment with docker files for ghcjs, the haskell to javascript compiler [ghcjs](https://github.com/ghcjs/ghcjs), as
minimal as possible against the latest ghcjs, built from the
[ghjcs installation instructions](https://github.com/ghcjs/ghcjs). Based on standard haskell:7.8 container
with alex and happy. 

You can use this container to play around with ghcjs, or use it as a
source to build a more specific image in a FROM chain.
Unlike https://github.com/rvl/ghcjs-docker, which uses git submodules I chose to download the
relevant ghcjs git repositories in the Docker file, so whenever you run
docker build you can get the latest versions. As long as the
installation instructions don't change this should work. 

That repository, on the
upside, has a normal user instead of the root user. So far, for
building things I haven't found much of an upside for adding a regular
users. for running a service perhaps. YMMV.

Suggestions and pull requests welcome. Happy hacking!
