# UCP — Numero (unità casi procedimenti istituite)

Conteggio delle Unità casi procedimenti (UCP) istituite per sede e anno — riforma "cartoline" / udienze preparatorie.

## Dati

- **Fonte**: Ministero della Giustizia — DG Statistica
- **File**: `UCP_2021_2025_Numero.csv` (`;`)
- **Copertura**: 2021–2025 (serie breve)
- **Grano**: anno × ufficio × sede (~700 righe)

## Caveat

- La fonte scrive "Anno 2021" (stringa con prefisso) — normalizzato in clean
- `Stato` è sempre "Convalidato" (colonna tracciabile, un valore)
- FORLI' nella fonte senza accento → Forlì
- Il censimento organizzativo dei singoli UCP (attività, personale) è in `ucp-dettaglio`

## Marts

- `ucp_numero`: passthrough per sede
- `mart_nazionale_trend`: totale per anno × tipo ufficio
