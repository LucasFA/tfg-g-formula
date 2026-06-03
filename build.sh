#! /usr/bin/env bash
#inside nix develop:

mkdir -p .cache/texmf-var

# please check .latexmkrc for other build options
latexmk -pvc tfg.tex
  # -interaction=nonstopmode # nonstopmode is default with .latexmkrc
