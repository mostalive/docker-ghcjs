FROM atddio/ghcjs-boot

#pre-download and pre-compile a number of ghcjs-libraries to make experimentation easier.

USER curry

RUN cabal update

RUN cabal install --help && \
    cabal -V && \
    which ghc && \
    ghc -V && \
    ghcjs -V

RUN git clone https://github.com/ghcjs/ghcjs-ffiqq \
    && cd ghcjs-ffiqq \
    && cabal install --ghcjs

RUN git clone https://github.com/ghcjs/ghcjs-vdom.git \
    && cd ghcjs-vdom \
    && cabal install --ghcjs

RUN git clone https://github.com/ghcjs/ghcjs-jquery.git \
    && cd ghcjs-jquery \
    && cabal install --ghcjs
#install vanilla-js.com for ajax instead of jquery?

RUN git clone https://github.com/ghcjs/ghcjs-canvas.git \
    && cd ghcjs-canvas \
    && cabal install --ghcjs

ADD matchuidgids.sh .

# the matchuidgids script needs to be root, and will switch to curry user afterwards
USER root
CMD /home/curry/matchuidgids.sh
