# Introducción a la inferencia causal y observacional

El trabajo en pdf está disponible en https://blog.lucasfa.com/tfg-g-formula/tfg.pdf

## Compilando el PDF

La compilación genera el archivo `build/tfg.pdf`.

### Con una instalación tradicional de LaTeX y R

Necesitas una distribución de LaTeX con `latexmk`, `xelatex` y los paquetes listados en `flake.nix`.
Ejecuta uno de los siguientes comandos:

```bash
./scripts/build.sh
./scripts/watch.sh
```

El repositorio incluye un archivo `.latexmkrc` con la configuración de compilación.
El primer comando produce el PDF, el segundo lo recompila en vivo con cada escritura si tienes
instalado `inotify-tools`

### Con Nix

Nix descargará automáticamente el compilador de LaTeX y todos los paquetes necesarios.
Este repositorio requiere el uso de [flakes](https://wiki.nixos.org/wiki/Flakes#Nix_standalone). En la raíz del proyecto:

```bash
nix build # (o nix build .#document)
```

Producirá el pdf bajo `./result/`

Si quieres desarrollar interactivamente:

```
nix develop
```

Producirá el pdf bajo `./build/`, y si modificas un archivo tex el pdf se recompilará en vivo.
Para que se abra tu editor de PDF favorito, modifica el campo `pdf_previewer` en `.latexmkrc`.

## Formateo del código

El proyecto incluye un comando para formatearlo automáticamente con `latexindent`.
Si usas Nix:

```
nix run .#format
```

Esto procesa `tfg.tex`, `library.bib` y los archivos .tex en `capitulos/`.
Configuración en `latexindent.yaml`.
