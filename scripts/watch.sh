#!/usr/bin/env bash
set -euo pipefail

mkdir -p .cache/texmf-var

latexmk -pvc tfg.tex
