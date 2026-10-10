# UCP — Dettaglio (censimento organizzativo)

Profilo organizzativo di ogni Unità casi procedimenti istituito: udienze preparatorie gestite (US), attività delegate del Procuratore (SPM/SAS/SAP), personale assegnato.

## Dati

- **Fonte**: Ministero della Giustizia — DG Statistica
- **File**: `UCP_2021_2025_Dettaglio_UCP.csv` (cp1252, ~48 colonne)
- **Script**: `scripts/prepare_dettaglio.py` — decodifica cp1252, sanifica header in snake_case, tipizza le colonne di conteggio
- **Copertura**: 2021–2025
- **Grano**: anno × sede × identificativo_ucp (~740 righe)

## Caveat

- **Somme del personale doppio-contano** gli stessi soggetti assegnati a più UCP della stessa sede (comportamento della fonte)
- Colonne SAS-/SAP- e SPM- (attività delegate, ~30 flag sparsi) sono nel raw preparato ma **non** nel clean (fuori grano analitico principale) — se servono, estendere il clean
- `supporto` è testuale ("Singolo Procuratore aggiunto o Sostituto Procuratore", …)
- Il conteggio UCP per sede/anno è nel dataset gemello `ucp-numero`

## Marts

- `ucp_dettaglio`: passthrough con personale e tipi US
- `mart_sintesi`: sede × anno → n_ucp + risorse aggregate
