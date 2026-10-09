#!/usr/bin/env bash
set -euo pipefail

mkdir -p .cache/texmf-var build

# Una compilación interrumpida deja auxiliares truncados (sin salto de línea
# final) que hacen fallar la siguiente: se limpian antes de compilar.
for f in build/tfg.aux build/tfg.bbl build/tfg.toc; do
  if [ -s "$f" ] && [ -n "$(tail -c1 "$f")" ]; then
    echo "$f truncado; limpiando auxiliares" >&2
    latexmk -c build/tfg.tex </dev/null || true
    break
  fi
done

# Knit tfg.Rnw (processes all <<child=...>>= includes in one session)
Rscript -e 'knitr::knit("tfg.Rnw", output = "build/tfg.tex")' </dev/null

latexmk build/tfg.tex </dev/null
