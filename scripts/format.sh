#!/usr/bin/env bash
set -euo pipefail

mkdir -p ./build
COMMAND="latexindent -l=latexindent.yaml -s -c ./build"

for file in tfg.tex library.bib ./capitulos/*.tex; do
  echo "Formatting $file with latexindent..."
  $COMMAND -o "$file" "$file"
done
