FROM atddio/ghcjs-cabal

USER curry
ENV PATH /home/curry/.cabal/bin:/opt/ghc/7.8.3/bin:/opt/cabal/1.20/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

RUN ghcjs-boot --dev
CMD ["/bin/bash"]


