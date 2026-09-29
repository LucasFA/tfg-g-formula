#!/usr/bin/env bash
set -euo pipefail

mkdir -p ./build
parallel --will-cite \
  'echo "Formatting {} with latexindent..."
   latexindent -l=latexindent.yaml -s -c ./build -o {} {}' \
  ::: library.bib ./capitulos/*.tex ./capitulos/*.Rnw
