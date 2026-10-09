# Giustizia Statistiche

Pipeline raw→clean→mart dei dati statistici giudiziariali del Ministero della Giustizia — Direzione Generale di Statistica e Analisi Organizzativa (`giustizia_statistiche`).

## Dataset

| Slug | Contenuto | Copertura |
|---|---|---|
| `civile-flussi` | Sopravvenuti, definiti, pendenti per ufficio — giustizia civile | 2014–2025 |
| `penale-flussi` | Sopravvenuti, definiti, pendenti per ufficio — giustizia penale | 2014–2025 |
| `monitoraggio-mensile-civile` | Iscritti e definiti civili per mese, sede e materia | 2019–2025 |
| `giustizia-penale-indicatori` | Clearance rate e disposition time per distretto e tipo ufficio | 2014–2025 |
| `giustizia-civile-indicatori` | Clearance rate e disposition time civili (SICID\|SIECIC) | 2014–2025 |
| `intercettazioni` | Bersagli intercettazioni per tipologia, ufficio e distretto | 2014–2025 |
| `spese-giustizia` | Spese a carico dell'erario liquidate dagli uffici giudiziari | 2014–2025 |
| `durata-civile` | Durata media procedimenti civili per materia (SICID + SIECIC) | 2014–2025 |
| `durata-penale-classi` | Distribuzione procedimenti penali per classe di tempo | 2014–2025 |
| `durata-penale-medie` | Durata media penale per sezione, sede e distretto | 2014–2025 |
| `monitoraggio-pnrr-giustizia` | Definiti e pendenti per sede con target PNRR (civile) | 2019–2026 |

Fonte unica: XLSX/CSV snapshot annuali su `datiestatistiche.giustizia.it`. Il file contiene l'intera serie storica; `years: [2025]` è la chiave di snapshot del run.

Intake aperti: mediazione civile (#4), OCC (#5), UCP (#6).

## Uso

```bash
make check   # preflight di tutti i dataset.yml
make run-all # run batch di tutti i dataset
make clean   # pulizia out/
```

Nota: `giustizia-penale-indicatori`, `giustizia-civile-indicatori`, `durata-civile` e `monitoraggio-pnrr-giustizia` richiedono `TOOLKIT_ALLOW_SCRIPT_SOURCE=1` (già imposto in `make run-all`).

## Contesto

- 4 dataset sono promossi/publicati via `dataset-incubator` (registry + GCS clean)
- Questo repo ne è la casa di produzione per il refresh
- Benchmark UE a confronto: `infra/eurostat` (crime NUTS3, prison, court cases, personnel)
- Giustizia amministrativa (OpenGA): `diritto-legge/giustizia-amministrativa`
