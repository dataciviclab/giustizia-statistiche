# Durata procedimenti civili (SICID + SIECIC)

Durata media dei procedimenti civili per materia, sede e anno. Due registri:

- **SICID**: civile ordinario (Tribunali e Corti d'Appello)
- **SIECIC**: esecuzioni (mobiliari, immobiliari, …)

## Dati

- **Fonte**: Ministero della Giustizia — DG Statistica
- **File**: `Durata_SICID_20142025.xlsx` + `Durata_SIECIC_20142025.xlsx`
- **Script**: `scripts/unite_durata_civile.py` (richiede `TOOLKIT_ALLOW_SCRIPT_SOURCE=1`)
- **Copertura**: 2014–2025
- **Grano**: anno × registro × livello × distretto × sede × materia

## Livelli di aggregazione

Il file contiene 3 livelli che sono **rollup della stessa realtà**:
`Circondariale` (base), `Distrettuale`, `Nazionale`. Il mart principale usa
solo Circondariale; il trend nazionale usa le righe Nazionale dove pubblicate,
altrimenti ricava dai circondari con media pesata per definiti.

## Caveat

- Durata media in giorni; SIECIC espone anche "anni" (non importato)
- Le medie tra SICID e SIECIC non sono confrontabili 1:1 (processi diversi)
- Complementa `giustizia-civile-indicatori` (disposition time per sede) con la
  vista per materia/registro

## Marts

- `durata_civile`: (anno, registro, distretto, sede, materia) → durata_media pesata
- `mart_nazionale_trend`: (anno, registro, materia) → durata nazionale + origine
