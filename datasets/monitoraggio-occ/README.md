# Monitoraggio OCC — crisi di sovraindebitamento

Flussi annuali delle procedure di sovraindebitamento gestite dagli Organismi di Composizione della Crisi, per tipologia, distretto e macro-area.

## Dati

- **Fonte**: Ministero della Giustizia — DG Statistica
- **File**: `Monitoraggio_OCC.csv` (`;`)
- **Copertura**: 2024–2025 (216 righe — serie breve)
- **Grano**: anno × macro_area × distretto × tipologia_procedimento

## Tipologie

- Concordato minore
- Liquidazione controllata
- Ristrutturazione dei debiti
- Esdebitazione del debitore incapiente

## Caveat

- **Genova** è spezzata su Nord + Centro (quota La Spezia): il distretto può attraversare le macro-aree — non sommare per distretto senza tener conto della spezzatura
- Colonne di esito (omologazione, rinuncia, apertura) popolate solo per alcune tipologie: null strutturali
- Serie storica corta (2 anni): ogni affermazione su trend va pesata
- Il sovraindebitamento è also noto come "legge anti-povertà" / legge 3/2012 — join potenziali con filone debito del Lab

## Marts

- `monitoraggio_occ`: grano pieno + delta pendenti + clearance rate
- `mart_nazionale_trend`: aggregato nazionale per tipologia
