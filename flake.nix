{
  # https://flyx.org/nix-flakes-latex/
  description = "Flake for building the TFG with nix";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    with flake-utils.lib;
    eachSystem allSystems (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        texCombined = pkgs.texlive.combine {
          inherit (pkgs.texlive)
            scheme-small
            latex-bin
            latexmk
            latexindent
            koma-script # template
            upquote
            fontaxes
            fontspec
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
            eso-pic
            dirtytalk
            ;
        };
      in
      rec {
        packages = {
          format = pkgs.writeShellApplication {
            name = "document-format";
            runtimeInputs = [ texCombined ];
            text = ''
              mkdir -p ./build
              for file in ./capitulos/*.tex; do
                echo "Formatting $file with latexindent..."
                latexindent -s -c ./build -o "$file" "$file"
              done  

              latexindent -s -c ./build -o library.bib library.bib
            '';
          };
          document = pkgs.stdenvNoCC.mkDerivation rec {
            name = "latex-demo-document";
            src = self;
            buildInputs = [
              pkgs.coreutils
              texCombined
            ];
            phases = [
              "unpackPhase"
              "buildPhase"
              "installPhase"
            ];
            buildPhase = ''
              export NIX_LOG_FD=1
              export PATH="${pkgs.lib.makeBinPath buildInputs}";
              mkdir -p .cache/texmf-var
              mkdir -p build
              env TEXMFHOME=.cache TEXMFVAR=.cache/texmf-var \
                latexmk -interaction=nonstopmode -pdf -xelatex \
                -outdir=build
                tfg.tex
            '';
            installPhase = ''
              mkdir -p $out
              cp build/tfg.pdf $out/
              cp build/tfg.log $out/
            '';
          };
        };
        formatter = pkgs.nixfmt-tree;
        defaultPackage = packages.document;
      }
    );
}
