#!/bin/sh
mkdir -p _shake
ghc --make Build.hs -Werror -rtsopts -with-rtsopts=-I0 -outputdir=_shake -o _shake/build && _shake/build "$@"
