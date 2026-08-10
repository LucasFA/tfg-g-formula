#!/usr/bin/env bash
set -euo pipefail

mkdir -p .cache/texmf-var build

knit()    { Rscript -e 'knitr::knit("tfg.Rnw", output = "build/tfg.tex")'; }
compile() { latexmk -f build/tfg.tex; }

knit && compile

inotifywait -m -e close_write --format '%w%f' \
  tfg.Rnw \
  *.tex \
  capitulos \
  preliminares \
  apendices \
  code \
  library.bib \
  | while read -r f; do
      knit && compile
  done
