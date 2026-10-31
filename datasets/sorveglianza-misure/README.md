# sorveglianza-misure

Provvedimenti dei Tribunali e degli Uffici di Sorveglianza sulle misure alternative alla detenzione: concessioni, revoche, cessazioni.

## Dati

- **Fonte**: Ministero della Giustizia — DG Statistica (datiestatistiche.giustizia.it)
- **File**: `Sorveglianza_misure_dati.csv`
- **Copertura**: 2020–2025, cadenza semestrale
- **Uffici**: Tribunale di sorveglianza, Ufficio di sorveglianza per adulti
- **Granularità**: nazionale, distrettuale (26 distretti), per sede (58)
- **Metriche**: numero di provvedimenti per tipo di misura e oggetto
- **Righe**: 45.411
- **Run**: `toolkit run all --config datasets/sorveglianza-misure/dataset.yml --years 2025` ✅
- **Licenza**: dati pubblici (Italian Open Data License v2.0)

## Attenzione

La colonna `Semestre` della fonte contiene anche il valore **`Anno`**, che è il totale annuale duplicato dei due semestri. Le righe sono mantenute e distinte da `periodo_tipo`:

- `periodo_tipo = 'semestre'` → `semestre` 1 o 2
- `periodo_tipo = 'anno'` → totale annuale (`semestre` NULL)

**Sommare `provvedimenti` senza filtrare `periodo_tipo` raddoppia i totali.** Il mart usa `periodo_tipo = 'anno'`.

## Colonne

| Colonna | Tipo | Note |
|---|---|---|
| `anno` | INTEGER | |
| `periodo_tipo` | VARCHAR | `semestre` / `anno` |
| `semestre` | INTEGER | 1, 2, NULL per il totale annuale |
| `tipo_ufficio` | VARCHAR | |
| `distretto` | VARCHAR | |
| `sede` | VARCHAR | `Bolzano/Bozen` normalizzato in `Bolzano` |
| `misura` | VARCHAR | Concesse, Revocate, Cessate per altri motivi, Cessate per sopravvenienza nuovi titoli, Dichiarate inefficaci |
| `oggetto` | VARCHAR | la misura specifica (affidamento, detenzione domiciliare, semilibertà, …) |
| `natura_misura` | VARCHAR | `alternativa` / `sostitutiva` / `cautelare` / `altro` |
| `provvedimenti` | INTEGER | |
