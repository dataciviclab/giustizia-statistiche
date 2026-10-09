# Spese giustizia

Importi liquidati dall'erario da tutti gli uffici giudiziari (esclusi UNEP), per anno, distretto, tipo di spesa e dettaglio.

## Dati

- **Fonte**: Ministero della Giustizia — DG Statistica (datiestatistiche.giustizia.it)
- **File**: `SpeseGiustizia_20142025.xlsx`, sheet `Dati`
- **Copertura**: 2014–2025 (file snapshot; `years: [2025]` è chiave di run)
- **Grano raw**: anno × distretto × tipo_spesa × dettaglio (~6.6k righe)
- **Distretti**: 26 (2014–2024); dal 2025 anche `NAZIONALE` e `INTERDISTRETTUALE` (voci reali, non totali)

## Caveat

- Importi = somme **impegnate** (decreti/ordinativi), non pagamenti effettuati (quelli sono presso gli uffici contabili)
- discontinuità di fonte 2025: Modello 1/A/SG → DATALAKE/SIAMM (aggiornato 12/04/2026)
- esclusi Uffici NEP/UNEP

## Marts

- `spese_giustizia`: (anno, distretto, tipo_spesa) → importo_totale, n_voci, n_dettagli
- `mart_nazionale_trend`: (anno, tipo_spesa) → importo_totale, quota_pct_anno
