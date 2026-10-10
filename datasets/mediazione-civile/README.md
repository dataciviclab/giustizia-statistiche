# Mediazione civile — flussi semestrali

Procedimenti di mediazione civile per distretto, tipologia di organismo e natura della pratica, con esiti (accordo raggiunto/non raggiunto, mancata comparizione).

## Dati

- **Fonte**: Ministero della Giustizia — DG Statistica
- **File**: `Mediazione_semestrale_*_Flussi.csv` (`;`) — **URL rotante**
- **Discovery**: `scripts/discover_flussi.py` risolve l'URL corrente dalla pagina [Rilevazioni civili](https://datiestatistiche.giustizia.it/page/it/rilevazioni_civili?contentId=TGN15023)
- **Copertura**: 2024-S1 → 2026-S1 (5 semestri)
- **Grano**: anno × semestre × distretto × tipologia_organismo × natura (~8.8k righe)
- **Tipologie organismo**: Camera di Commercio, Ordine Avvocati, Altri ordini professionali, Organismi privati
- **Nature**: 22 (affitto d'aziende, risarcimento danni, condominio, …)

## Caveat

- Aggiornamento **semestrale** — non confrontabile 1:1 con le serie annuali degli altri dataset; usare `semestre` nei filtri
- Il nome del file cambia a ogni update: lo script di discovery risolve l'URL, ma se il Ministero rinomina il pattern regex va aggiornato
- Tasso di accordo = accordi raggiunti / (raggiunti + non raggiunti), cioè sulle sole mediazioni con aderente comparso
- Altre statistiche mediazione (Organismi, Categoria, Durata, Assistenza) sono CSV separati con grani diversi — non inclusi in v0

## Marts

- `mediazione_civile`: grano pieno + tasso_accordo
- `mart_nazionale_trend`: nazionale per semestre × tipologia organismo
