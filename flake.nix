{
  # https://flyx.org/nix-flakes-latex/
  description = "Flake for building the TFG with nix";
  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixos-25.05;
    flake-utils.url = github:numtide/flake-utils;
  };
  outputs = { self, nixpkgs, flake-utils }:
    with flake-utils.lib; eachSystem allSystems (system:
    let
      pkgs = nixpkgs.legacyPackages.${system};
      tex = pkgs.texlive.combine {
          inherit (pkgs.texlive) scheme-small latex-bin latexmk
            koma-script # template
            upquote fontaxes fontspec
# inputenc 
babel
amsmath
# amsthm 
# amssymb 
mathtools
# eucal 
# aliascnt
microtype
# fontenc
mathpazo
cabin 
inconsolata
setspace
# xspace
xurl
hyperref
booktabs
xcolor 
# graphicx
listings
biblatex
eso-pic;
      };
    in rec {
      packages = {
        document = pkgs.stdenvNoCC.mkDerivation rec {
        name = "latex-demo-document";
          src = self;
          buildInputs = [pkgs.coreutils tex ];
          phases = ["unpackPhase" "buildPhase" "installPhase"];
          buildPhase = ''
            export NIX_LOG_FD=1
            export PATH="${pkgs.lib.makeBinPath buildInputs}";
            mkdir -p .cache/texmf-var
            env TEXMFHOME=.cache TEXMFVAR=.cache/texmf-var \
              latexmk -interaction=nonstopmode -pdf -pdflatex \
              tfg.tex
          '';
          installPhase = ''
            mkdir -p $out
            cp tfg.pdf $out/
            cp tfg.log $out/
          '';
      };
        };
      defaultPackage = packages.document;
    });
}

