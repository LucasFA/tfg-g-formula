#!/usr/bin/env bash
#inside nix develop:
set -euo pipefail

mkdir -p .cache/texmf-var
mkdir -p build

# please check .latexmkrc for build options
latexmk tfg.tex
