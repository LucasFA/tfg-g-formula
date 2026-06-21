#!/usr/bin/env bash
set -euo pipefail

mkdir -p .cache/texmf-var build

knit()    { Rscript -e 'knitr::knit("tfg.Rnw", output = "build/tfg.tex")'; }
compile() { latexmk -f build/tfg.tex; }

knit && compile

inotifywait -m -e modify -q --format '%w%f' \
  **.Rnw \
  **.tex \
  code/* \
  library.bib \
  | while read -r f; do
      knit && compile
  done
