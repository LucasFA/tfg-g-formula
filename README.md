# Introducción a la inferencia causal y observacional

## Compilando el PDF

En Windows y Linux pero con los paquetes apropiados de Latex (que vendrían incluidos en muchas distribuciones de Latex por defecto,
véase el archivo `flake.nix` para una lista completa),
bastaría con ejecutar `./build.sh` en bash, o respectivamente su contenido `latexmk -pvc tfg.tex`, en una terminal.
El repositorio incluye un archivo `.latexmkrc` con configuración de compilación.

También puedes compilar el pdf con el gestor de paquetes `nix`, habilitando flakes y ejecutando `nix develop --command ./build.sh` en el
directorio raíz del proyecto. Descargará un compilador de Latex y paquetes necesarios para la compilación por su cuenta.
