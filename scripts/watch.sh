#!/usr/bin/env bash
# Sin `set -e`: un error de R o de LaTeX no debe terminar el watch.
set -uo pipefail

mkdir -p .cache/texmf-var build

# stdin a /dev/null: si no, R o latexmk pueden consumir los nombres de archivo
# que inotifywait manda por la tubería.
knit()    { Rscript -e 'knitr::knit("tfg.Rnw", output = "build/tfg.tex")' </dev/null; }
compile() { latexmk -f build/tfg.tex </dev/null; }

# Una compilación interrumpida deja auxiliares truncados (sin salto de línea
# final) que hacen fallar la siguiente: se limpian antes de compilar.
heal() {
  local f
  for f in build/tfg.aux build/tfg.bbl build/tfg.toc; do
    if [ -s "$f" ] && [ -n "$(tail -c1 "$f")" ]; then
      echo "$f truncado; limpiando auxiliares" >&2
      latexmk -c build/tfg.tex </dev/null || true
      return
    fi
  done
}

build() {
  heal
  if knit && compile; then
    echo "Compilación correcta." >&2
  else
    echo "Compilación con errores; esperando cambios..." >&2
  fi
}

build

inotifywait -m -e close_write --format '%w%f' \
  tfg.Rnw \
  *.tex \
  capitulos \
  preliminares \
  apendices \
  code \
  library.bib \
  | while read -r f; do
      build
  done
