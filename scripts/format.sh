#!/usr/bin/env bash
set -euo pipefail

mkdir -p ./build
parallel --will-cite \
  'echo "Formatting {} with latexindent..."
   latexindent -l=latexindent.yaml -s -c ./build -o {} {}' \
  ::: library.bib tfg.Rnw glosario.tex ./capitulos/*.tex ./capitulos/*.Rnw \
    ./apendices/*.tex ./preliminares/*.tex
