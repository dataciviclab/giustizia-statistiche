# Compose quadro-distretto

Una riga per distretto (26) che risponde: **come sta andando la giustizia in questo distretto?** — volumi civile/penale, efficienza, coda lunga, costo erario, ritardo PNRR.

## Fonti (9 dataset del repo)

| Dataset | Contributo |
|---|---|
| `civile_flussi` | sopravvenuti/definiti/pendenti civile (spina dorsale) |
| `penale_flussi` | idem penale (somma uffici) |
| `giustizia_civile_indicatori` | clearance + disposition time civile (Tribunali) |
| `giustizia_penale_indicatori` | idem penale |
| `durata_penale_classi` | quota procedimenti penali oltre 2 anni |
| `spese_giustizia` | spesa erario totale (→ euro/procedimento civile) |
| `monitoraggio_pnrr_giustizia` | pendenti civili Tribunali vs target 2026 |
| `sorveglianza_misure` | concessioni e revoche di misure alternative (flusso annuale) |
| `sorveglianza_esecuzione` | misure alternative in esecuzione al 31/12 (stock) |

## Esecuzione

I dataset membro devono essere runnati **prima** del compose (`make run-all` o singoli). Poi:

```bash
toolkit run --config compose/quadro-distretto/dataset.yml
```

## Caveat

- Snapshot **2025** (il PNRR espone il 2026 solo come target)
- Indicatori e quota penale: solo **Tribunali** (le CA hanno grano proprio)
- **Quota oltre 2 anni**: classi 'oltre 2 anni' + 'oltre 3 anni'; le sezioni con classificazione a 4 mesi non sono confrontabili → quota in sottostima
- **PNRR**: i target riguardano il **cohort dei vecchi arretrati** (pendenti al 31/12/2022, iscritti dal 2017), NON la pendenza totale. Esposti: `pnrr_cohort_2026` (quanto del cohort è ancora vivo), `pnrr_cohort_baseline_2026` (dimensione iniziale), `pnrr_cohort_pct_residuo` (target ≤ 10%), `pnrr_sotto_target_2026`
- Spese escluse le righe Nazionale/Interdistrettuale
- **Sorveglianza**: `sorv_stock_alternative` filtra `natura_misura='alternativa'`. Senza filtro lo stock include sostitutive (libertà controllata, semidetenzione, lavoro sostitutivo) e cautelari (arresti domiciliari), che non sono confrontabili con le misure alternative. `sorv_revoca_pct = revocate / concesse` (flusso annuo, non stock).

## Marts

- `mart_quadro`: 26 righe + euro_per_procedimento_civ, metriche cohort PNRR, sorveglianza (concesse, revocate, revoca_pct, stock misure alternative)
- `mart_nazionale`: 1 riga Italia (medie pesate sui definiti)
