IDEAS:

1. La sensitividad requerida sobre los covariantes no medidos. Vease el el libro Causal inference de Rosenbaum.
Capitulo 5.

## Nuevas secciones:
- Estimadores. Después de el de identificación. [In progress]
- Estimandos. Donde ahora está lo de "estimadores". Trata RD, RR, OR [In progress -- Pasar a estimandos causales]
- Dos nuevos apartados: resultados y conclusiones, de la parte práctica

## Nuevos temas a tratar:
- Más DAGs para SCM 
Dos métodos a tratar, como extensión
- Resampling IPTW
- double robust estimation (DRE)
DRE basado en RA (regression adjustment) + IPTW
Los dos de arriba es en ese orden histórico

Verlos en ejemplo con la simulación de MC (o datos reales?), donde se rompa randomización la comparacion

## Otras modificaciones
- Introducción dando punto de vista práctico con perspectiva computacional
- Más métodos clásicos tipo ANOVA o t test (low priority)
- sección de Estimandos donde ahora está estimadores, con lo de RR y stuff [Done - ver sección `nuevas secciones`]
## Nuevos recursos:
- Paper: USING SIMULATION STUDIES TO simulate statistical methods. Wiley

## Lista de TODOs ordenada:

- RCT. Tiene intercambiabioidad, (hipótesis más debil), por la randomizacion del tratamiento.
- En RCT Podemos hacer ajuste de regresión estilo el lineal sin preocuparnos de confounding, pero no en observacionales.
- Así que introducir RA para RCT caso binario, caso ATE, usar diferencia de medias, ver que es insesgado y su intervalo de confianza.
- introducir confounding con DAG, luego IPW, luego doubly robust.
- Ver cómo introducir la visión del doubly robust estimator basado en EIF

## Lista vieja de TODOs
- [] merge in library.bib:
  - [] oxChapterCausal
  - [] oxChapterOutcome
- [] Decide on title (eg the language)
