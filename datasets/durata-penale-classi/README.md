# Durate penali per classi di tempo

Distribuzione dei procedimenti penali definiti per classe di tempo di definizione (entro 6 mesi, 6m-1a, 1-2a, oltre 2a…). Complementa `giustizia-penale-indicatori`: lì c'è la media (disposition time), qui la **forma della coda**.

## Dati

- **Fonte**: Ministero della Giustizia — DG Statistica
- **File**: `Durate_penali_per_classi_20142025.csv` (export CSV, delimitatore `;`)
- **Copertura**: 2014–2025 (~45k righe di dati)
- **Nota export**: il CSV ha ~967k righe di padding vuoto — scartate dal clean

## Caveat

- Le classi di tempo non sono uniformi tra sezioni (es. "entro 4 mesi" vs "entro 6 mesi") — il join tra sezioni va fatto sulla classificazione reale, non per confronto diretto delle label
- Sezione ufficio = Assise, Corte d'Assise Appello, Tribunale monocratico, … — la classe dipende dal rito
- Foglio XLSX "Circondari soppressi" non importato (riferimento d.lgs. 155/2012)

## Marts

- `durata_penale_classi`: grano pieno (anno×ufficio×distretto×sede×sezione×classe)
- `mart_classi_sintesi`: quote % per classe su (anno, distretto, ufficio)

## Sibling

- `durata-penale-medie`: durata media per dettaglio territoriale (stessa fonte, foglio diverso)
