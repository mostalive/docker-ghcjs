FROM atddio/ghcjs-libs
USER root

RUN echo "deb-src http://ftp.uk.debian.org/debian stable main contrib" >> /etc/apt/sources.list && \
    apt-get update && \
    apt-get -y build-dep emacs23-nox && \ 
    apt-get -y install vim tmux zlib1g-dev autoconf automake build-essential wget

RUN wget http://ftp.gnu.org/gnu/emacs/emacs-24.4.tar.gz

RUN ls -la && \
    tar -xvzf emacs-24.4.tar.gz && \
    cd emacs-24.4 && \
    ./configure && \
    make && \
    make install
    

USER curry
ADD dot-emacs-arnaud.el /home/curry/.emacs
RUN mkdir /home/curry/emacs-install
ADD emacs-install-packages.sh /home/curry/emacs-install/
WORKDIR /home/curry/emacs-install
 
RUN cabal sandbox init && \ 
    cabal install --max-backjumps=-1 --reorder-goals --force-reinstalls hdevtools hlint ghc-mod hasktags 

# there is more than one ghci-ng from the looks of it, and it is not the package on hackage we need
RUN git clone https://github.com/chrisdone/ghci-ng && \
    cabal install ghci-ng/ 

RUN pwd && \
    ls -la && \
    bash emacs-install-packages.sh
# finding our binaries back in emacs
RUN echo "export PATH=$HOME/emacs-install/.cabal-sandbox/bin/:$HOME/ghci-ng/.cabal-sandbox/bin:$PATH" >> /home/curry/.bashrc
# to ensure uid / gid change script works
USER root
