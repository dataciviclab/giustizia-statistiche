# Note — sorveglianza-esecuzione

## Fonte

- Pagina: https://datiestatistiche.giustizia.it/it/sorveglianza.page
- File: `Sorveglianza_misure_esecuzione_dati.csv` (1,5 MB, delimitatore `;`, UTF-8 con BOM)
- Cadenza semestrale

## Trappole verificate

1. **`Tipologia` distingue stock e flusso**: `Aperte nel periodo` → `flusso`, `Aperte a fine periodo` → `stock`. Sommare le due voci raddoppia.
2. **BOM UTF-8**: reader DuckDB con `encoding: utf-8` (non `utf-8-sig`).
3. **`Misura` è costante** (`In esecuzione`): scartata nel clean.
4. **Natura eterogenea**: lo stock contiene misure alternative, sostitutive (libertà controllata) e cautelari (arresti domiciliari). La mappa `natura_misura` usa pattern `LIKE` ed è **duplicata** in `sorveglianza-misure/sql/clean.sql`: se cambia in un file va cambiata nell'altro (il contratto clean non espone macro condivise).
5. **Il lavoro esterno (art. 21 O.P.) non compare in questo file**: la fonte non lo traccia nello stock, anche se nel file `sorveglianza-misure` è classificato come `alternativa`. Il confronto flusso/stok su quella voce non è possibile con i dati pubblicati.

## Numeri di controllo (2025, `tipologia='stock'`)

| Natura | Provvedimenti |
|---|---:|
| alternativa | 73.646 |
| sostitutiva | 29.751 |
| cautelare | 4.315 |
| altro | 8 |
| **totale** | **107.720** |

Confronto: detenuti presenti al 31/12/2025 = 63.499 (Ministero della Giustizia). Il confronto è **indicativo**: provvedimenti ≠ persone, e lo stock include voci non alternative.
