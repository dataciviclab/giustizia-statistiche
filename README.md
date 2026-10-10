# Giustizia Statistiche

[![CI](https://github.com/dataciviclab/giustizia-statistiche/actions/workflows/ci.yml/badge.svg)](https://github.com/dataciviclab/giustizia-statistiche/actions/workflows/ci.yml)

Ogni anno i tribunali italiani definiscono centinaia di migliaia di procedimenti — ma quanto tempo ci mettono, quanto costa all'erario e dove il sistema regge meglio? Questo repo rende interrogabili i dati statistici ufficiali del **Ministero della Giustizia — Direzione Generale di Statistica**: flussi civili e penali, durate, efficienza, intercettazioni, spese e monitoraggio PNRR, per ufficio giudiziario, distretto e anno.

## Cosa contengono

12 dataset, tutti dalla stessa fonte (`datiestatistiche.giustizia.it`), copertura **2014–2026** (salvo eccezioni indicate).

| Dataset | Righe | Periodo | Contenuto |
|---|---|---|---|
| `civile_flussi` | 123.203 | 2014–2025 | Sopravvenuti, definiti, pendenti per ufficio — civile |
| `monitoraggio_mensile_civile` | 144.490 | 2019–2025 | Iscritti/definiti civili per mese, sede e materia |
| `giustizia_civile_indicatori` | 76.799 | 2014–2025 | Clearance rate e disposition time civili (SICID/SIECIC) |
| `durata_penale_classi` | 45.600 | 2014–2025 | Distribuzione procedimenti penali per classe di tempo |
| `durata_civile` | 21.840 | 2014–2025 | Durata media civile per materia (ordinario + esecuzioni) |
| `durata_penale_medie` | 16.697 | 2014–2025 | Durata media penale per sezione d'ufficio |
| `penale_flussi` | 17.652 | 2014–2025 | Sopravvenuti, definiti, pendenti per ufficio — penale |
| `giustizia_penale_indicatori` | 10.478 | 2014–2025 | Clearance rate e disposition time penali |
| `spese_giustizia` | 6.594 | 2014–2025 | Spese a carico dell'erario liquidate dagli uffici |
| `intercettazioni` | 3.952 | 2014–2025 | Bersagli intercettazioni per tipologia e ufficio |
| `monitoraggio_pnrr_giustizia` | 2.720 | 2019–2026 | Definiti/pendenti per sede con target PNRR (civile) |
| `monitoraggio_occ` | 216 | 2024–2025 | Flussi sovraindebitamento (OCC) per tipologia e distretto |

## Esempi di domande

- In quali distretti il civile definisce più procedimenti di quanti ne iscrive (clearance rate > 1)?
- Quanto pende ancora un procedimento penale a Salerno vs Milano, e come è cambiato dal 2014?
- Quanto ha speso l'erario per gli uffici giudiziari nel 2025, e quanto pesano onorari vs indennità?
- Quali tribunali stanno avvicinandosi ai target PNRR di riduzione dei pendenti al 2026?
- Quanti procedimenti penali restano oltre i 2 anni di definizione in ogni distretto?

## Come accedere

Ogni dataset ha un `dataset.yml` (contratto raw→clean→mart) e marts aggregati pronti all'uso.

**DuckDB direttamente sui parquet** (output locale dopo `make run-all`):

```sql
SELECT distretto, clearance_rate_medio
FROM 'out/data/mart/giustizia_penale_indicatori/2025/*.parquet'
WHERE anno = 2025 AND tipo_ufficio = 'Tribunale'
ORDER BY clearance_rate_medio DESC;
```

**Pipeline** (richiede [toolkit](https://github.com/dataciviclab/toolkit)):

```bash
make check    # preflight di tutti i dataset.yml
make run-all  # download + clean + mart di tutti i dataset
```

**Sorgente**: XLSX/CSV snapshot annuali su `datiestatistiche.giustizia.it`; il file copre l'intera serie, `years: [2025]` è la chiave di snapshot del run.

## Approfondimenti

- Benchmark UE a confronto: [infra/eurostat](https://github.com/dataciviclab/eurostat) (crime NUTS3, prison, court cases, personnel)
- Giustizia amministrativa (OpenGA): [diritto-legge/giustizia-amministrativa](https://github.com/dataciviclab/giustizia-amministrativa)
- Intake ancora aperti: [mediazione civile](https://github.com/dataciviclab/giustizia-statistiche/issues/4), [OCC sovraindebitamento](https://github.com/dataciviclab/giustizia-statistiche/issues/5), [UCP](https://github.com/dataciviclab/giustizia-statistiche/issues/6)

## Partecipa

Hai trovato un'anomalia nei dati o una domanda che questi dataset non rispondono ancora? Apra una [issue](https://github.com/dataciviclab/giustizia-statistiche/issues) o una [Discussion](https://github.com/dataciviclab/giustizia-statistiche/discussions). Le proposte di nuovi dataset dal portale del Ministero sono benvenute.

## Licenza

I dataset riproducono dati statistici pubblici del Ministero della Giustizia (verificare le note legali del portale per i termini di riuso dei dati). Codice e pipeline di questo repo: [MIT](LICENSE).
