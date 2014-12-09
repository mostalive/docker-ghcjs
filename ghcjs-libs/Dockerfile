FROM atddio/ghcjs-boot

#pre-download and pre-compile a number of ghcjs-libraries to make experimentation easier.

USER curry

RUN git clone https://github.com/ghcjs/ghcjs-base \
    && cd ghcjs-base \
    && cabal install --ghcjs -j4 

RUN git clone https://github.com/ghcjs/ghcjs-ffiqq \
    && cd ghcjs-ffiqq \
    && cabal install --ghcjs -j4

RUN git clone https://github.com/ghcjs/ghcjs-vdom.git \
    && cd ghcjs-vdom \
    && cabal install --ghcjs -j4 

RUN git clone https://github.com/ghcjs/ghcjs-dom.git \
    && cd ghcjs-dom \
    && cabal install --ghcjs -j4 

RUN git clone https://github.com/ghcjs/ghcjs-jquery.git \
    && cd ghcjs-jquery \
    && cabal install --ghcjs -j4 
#install vanilla-js.com for ajax instead of jquery?

RUN git clone https://github.com/ghcjs/ghcjs-canvas.git \
    && cd ghcjs-canvas \
    && cabal install --ghcjs -j4 
