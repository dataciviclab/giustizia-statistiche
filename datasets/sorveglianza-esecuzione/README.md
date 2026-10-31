# sorveglianza-esecuzione

Misure in esecuzione presso gli Uffici di Sorveglianza: flusso (aperte nel periodo) e stock (in essere al 31/12).

## Dati

- **Fonte**: Ministero della Giustizia — DG Statistica (datiestatistiche.giustizia.it)
- **File**: `Sorveglianza_misure_esecuzione_dati.csv`
- **Copertura**: 2020–2025
- **Uffici**: Ufficio di sorveglianza per adulti, Tribunale di Sorveglianza
- **Granularità**: nazionale, distrettuale (26 distretti), per sede (58)
- **Metriche**: numero di provvedimenti in esecuzione
- **Righe**: 11.148
- **Run**: `toolkit run all --config datasets/sorveglianza-esecuzione/dataset.yml --years 2025` ✅
- **Licenza**: dati pubblici (Italian Open Data License v2.0)

## Attenzione

`tipologia` distingue due misure diverse:

- `flusso` = "Aperte nel periodo" (misure avviate nell'anno)
- `stock` = "Aperte a fine periodo" (misure in essere al 31/12)

**Non sommarle.** Per il numero di persone in misura alternativa in un dato momento serve `stock`.

Lo stock mescola nature diverse: `natura_misura` separa `alternativa`, `sostitutiva` (libertà controllata, semidetenzione, lavoro sostitutivo), `cautelare` (arresti domiciliari) e `altro` (sospensione condizionata). Senza questo filtro il totale è interpretabile male.

## Colonne

| Colonna | Tipo | Note |
|---|---|---|
| `anno` | INTEGER | |
| `tipologia` | VARCHAR | `flusso` / `stock` |
| `tipo_ufficio` | VARCHAR | |
| `distretto` | VARCHAR | |
| `sede` | VARCHAR | `Bolzano/Bozen` normalizzato in `Bolzano` |
| `oggetto` | VARCHAR | tipo di misura |
| `natura_misura` | VARCHAR | `alternativa` / `sostitutiva` / `cautelare` / `altro` |
| `provvedimenti` | INTEGER | |
