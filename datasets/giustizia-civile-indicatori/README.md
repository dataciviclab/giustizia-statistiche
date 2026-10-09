# Giustizia civile — clearance rate e disposition time

## Domanda

Dove il sistema civile smaltisce meglio e dove invece i procedimenti restano più a lungo in carico?

## Dati

- **Fonte**: Ministero della Giustizia — DG Statistica (datiestatistiche.giustizia.it)
- **File**: `Indicatori_Civili.xlsx` (3 fogli)
- **Script**: `scripts/unite_sheets_civili.py` — scarica XLSX e unisce i fogli in CSV
- **Run**: richiede `TOOLKIT_ALLOW_SCRIPT_SOURCE=1`

| Foglio | Copertura | Particolarità |
|---|---|---|
| Tribunali e Corti d'Appello | 2014–2025 | Fonte SICID\|SIECIC; colonna Tipo ufficio |
| Giudici di Pace | 2023–2025 | senza Fonte/Tipo ufficio (foglio dedicato) |
| Tribunali per i Minorenni | 2023–2025 | senza Distretto (nazionale) |

## Caveat

- Indicatori **già derivati** (come il penale): non permettono di ricostruire i procedimenti originali
- GiP e Minorenni hanno solo 3 anni → trend/CAGR su base breve, non confrontabile col filone Tribunali/CA
- Disposition time in giorni; clearance rate = definiti/iscritti
- Fonte del foglio principale: SICID (civile ordinario) e SIECIC (esecuzioni) — discontinuità di registro da tenere a mente nei join con Durata_SICID/SIECIC

## Marts

- `giustizia_civile_indicatori`: (anno, distretto, tipo_ufficio) → media/min/max CR e DT per sede
- `mart_civile_trend`: (distretto, tipo_ufficio) → delta e CAGR primo/ultimo anno

## Sibling

`giustizia-penale-indicatori` — stesso design, ambito penale.
