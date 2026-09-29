{
  # https://flyx.org/nix-flakes-latex/  https://github.com/flyx/flyx.org/blob/master/nix-flakes-latex.md
  description = "Flake for building the TFG with nix";
  inputs = {
    nixpkgs.url = "https://channels.nixos.org/nixos-unstable/nixexprs.tar.zst";
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
        rWithPkgs = pkgs.rWrapper.override {
          packages = with pkgs.rPackages; [
            knitr
            ggdag
            # lavaan
            simcausal
            simDAG

            languageserver
            lintr
          ];
        };
        texIndent = pkgs.texliveSmall.withPackages (
          ps: with ps; [
            scheme-basic
            latexindent
          ]
        );
        texCombined = pkgs.texliveSmall.withPackages (
          ps: with ps; [
            scheme-small
            # fpl # fonts? URW Palladio

            latexmk
            koma-script # template
            upquote
            fontaxes
            fontspec

            # lista obtenida con `cat ugrTFG.cls | grep RequirePackage`
            # paquetes comentados con # no están en nixpkgs con ese nombre,
            # pero siguen estando disponibles en la compilación.

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
            eso-pic
            dirtytalk
            tikz-cd
            framed
          ]
        );
      in
      rec {
        devShells.default = pkgs.mkShell {
          packages = [
            texCombined
            texIndent
            pkgs.coreutils
            pkgs.inotify-tools
            pkgs.parallel
            rWithPkgs
          ];
        };

        packages = {
          live-compilation = pkgs.writeShellApplication {
            name = "Live recompilation";
            runtimeInputs = [ ];
            text = ''
              ${pkgs.bash}/bin/bash ./scripts/watch.sh
            '';
          };

          # Ejecutar con `nix run .#format`
          format = pkgs.writeShellApplication {
            name = "document-format";
            runtimeInputs = [ texIndent pkgs.parallel ];
            text = ''
              ${pkgs.bash}/bin/bash ./scripts/format.sh
            '';
          };
          document = pkgs.stdenvNoCC.mkDerivation rec {
            name = "Compile project";
            src = self;
            buildInputs = [
              pkgs.coreutils
              texCombined
              rWithPkgs
            ];
            phases = [
              # prevent the fixup phase. It throws errors
              "unpackPhase"
              "buildPhase"
              "installPhase"
            ];
            buildPhase = ''
               export NIX_LOG_FD=1
               export PATH="${pkgs.lib.makeBinPath buildInputs}";
              ${pkgs.bash}/bin/bash ./scripts/build.sh
            '';
            installPhase = ''
              mkdir -p $out
              cp build/tfg.pdf $out/
              cp build/tfg.log $out/
            '';
          };
        };
        # this formatter is for nix, not for the latex project.
        # Check out the above `format` package
        formatter = pkgs.nixfmt-tree;
        defaultPackage = packages.document;
      }
    );
}
