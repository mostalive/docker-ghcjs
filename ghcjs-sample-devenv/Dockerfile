FROM atddio/ghcjs-libs

USER root
ENV DEBIAN_FRONTEND non-interactive
RUN apt-get install -y apt-utils inotify-tools

USER curry

WORKDIR /home/curry
ADD rerun-cabal.sh /home/curry/
ADD . /home/curry/app

VOLUME /home/curry/app


CMD ["/home/curry/rerun-cabal.sh"]

