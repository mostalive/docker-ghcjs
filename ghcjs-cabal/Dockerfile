FROM haskell:7.8

ENV DEBIAN_FRONTENT non-interactive

RUN apt-get update \
    && apt-get -y install build-essential git zlib1g-dev libtinfo-dev libgmp-dev autoconf curl

RUN curl -sL https://deb.nodesource.com/setup | bash - \
    && apt-get install -y nodejs

RUN addgroup --gid 1001 curry \
     && adduser --disabled-password --gecos "dontcare" --gid 1001 --uid 1001 -home /home/curry curry

USER curry
WORKDIR /home/curry

RUN git clone https://github.com/ghcjs/cabal.git \
    && cd cabal \
    && git checkout ghcjs \
    && cabal update \
    && cabal install -j4 ./Cabal ./cabal-install

RUN git clone https://github.com/ghcjs/ghcjs-prim.git \
    && git clone https://github.com/ghcjs/ghcjs.git \
    && cabal update \
    && cabal install -j4 --reorder-goals ./ghcjs ./ghcjs-prim


