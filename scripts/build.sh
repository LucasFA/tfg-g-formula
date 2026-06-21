#!/usr/bin/env bash
set -euo pipefail

mkdir -p .cache/texmf-var build

# Knit tfg.Rnw (processes all <<child=...>>= includes in one session)
Rscript -e 'knitr::knit("tfg.Rnw", output = "build/tfg.tex")'

latexmk build/tfg.tex
