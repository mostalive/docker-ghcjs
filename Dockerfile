FROM haskell:7.8

ENV DEBIAN_FRONTENT non-interactive

RUN apt-get update \
    && apt-get -y install build-essential git zlib1g-dev libtinfo-dev libgmp-dev autoconf curl

RUN curl -sL https://deb.nodesource.com/setup | bash - \
    && apt-get install -y nodejs

RUN git clone https://github.com/ghcjs/cabal.git \
    && cd cabal \
    && git checkout ghcjs \
    && cabal update \
    && cabal install ./Cabal ./cabal-install

RUN git clone https://github.com/ghcjs/ghcjs-prim.git \
    && git clone https://github.com/ghcjs/ghcjs.git \
    && cabal install --reorder-goals --max-backjumps=1 ./ghcjs ./ghcjs-prim

ENV PATH ./root/.cabal/bin:/opt/ghc/7.8.3/bin:/opt/cabal/1.20/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

RUN PATH=./root/.cabal/bin:$PATH ghcjs-boot --dev
CMD ["/bin/bash"]


