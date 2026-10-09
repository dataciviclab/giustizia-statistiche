# Durate medie penali

Durata media di definizione dei procedimenti penali per sezione d'ufficio, sede, distretto e anno. Tre livelli territoriali nello stesso file: Nazione, Distretto, Sede (discriminati da `dettaglio_territoriale`).

## Dati

- **Fonte**: Ministero della Giustizia — DG Statistica
- **File**: `Durate_medie_penali_20142025.csv` (export CSV, delimitatore `;`)
- **Copertura**: 2014–2025 (~17k righe di dati)
- **Nota export**: ~1M righe di padding vuoto — scartate dal clean

## Caveat

- Le medie sono per sezione d'ufficio (Assise, GIP, PM, …) — non medie per sede complessive
- Confrontare con `durata-penale-classi` (distribuzione) e `giustizia-penale-indicatori` (disposition time)
- Il CSV arrotonda le medie a interi; l'XLSX originale ha i float pieni — se servono decimali, passare all'XLSX via script

## Marts

- `durata_penale_medie`: righe Nazione + Sede (livelli analitici)
