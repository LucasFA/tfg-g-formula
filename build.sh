#! /usr/bin/env bash
#inside nix develop:

export NIX_LOG_FD=1
mkdir -p .cache/texmf-var
env TEXMFHOME=.cache TEXMFVAR=.cache/texmf-var \
	latexmk -pdf -pvc tfg.tex -xelatex

              #latexmk -interaction=nonstopmode -pdf -xelatex \
              # tfg.tex

