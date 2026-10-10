# Compose quadro-distretto

Una riga per distretto (26) che risponde: **come sta andando la giustizia in questo distretto?** — volumi civile/penale, efficienza, coda lunga, costo erario, ritardo PNRR.

## Fonti (7 dataset del repo)

| Dataset | Contributo |
|---|---|
| `civile_flussi` | sopravvenuti/definiti/pendenti civile (spina dorsale) |
| `penale_flussi` | idem penale (somma uffici) |
| `giustizia_civile_indicatori` | clearance + disposition time civile (Tribunali) |
| `giustizia_penale_indicatori` | idem penale |
| `durata_penale_classi` | quota procedimenti penali oltre 2 anni |
| `spese_giustizia` | spesa erario totale (→ euro/procedimento civile) |
| `monitoraggio_pnrr_giustizia` | pendenti civili Tribunali vs target 2026 |

## Esecuzione

I dataset membro devono essere runnati **prima** del compose (`make run-all` o singoli). Poi:

```bash
toolkit run --config compose/quadro-distretto/dataset.yml
```

## Caveat

- Snapshot **2025** (il PNRR espone il 2026 solo come target)
- Indicatori e quota penale: solo **Tribunali** (le CA hanno grano proprio)
- **Quota oltre 2 anni**: classi 'oltre 2 anni' + 'oltre 3 anni'; le sezioni con classificazione a 4 mesi non sono confrontabili → quota in sottostima
- **PNRR**: target presenti solo per alcune sedi — la somma distretto è su target non nulli
- Spese escluse le righe Nazionale/Interdistrettuale

## Marts

- `mart_quadro`: 26 righe + euro_per_procedimento_civ, pnrr_scarto_vs_target, pnrr_pct_target
- `mart_nazionale`: 1 riga Italia (medie pesate sui definiti)
