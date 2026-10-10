# Monitoraggio PNRR giustizia — definiti e pendenti per sede

Serie 2019–2026 (H1) di definiti e pendenti per sede, con target PNRR sul civile. Il dataset cuore della narrativa "il PNRR giustizia sta funzionando?".

## Dati

- **Fonte**: Ministero della Giustizia — DG Statistica
- **File**: `Monitoraggio_PNRR_Dati_civili.csv` + `Monitoraggio_PNRR_Dati_penali.csv` (`;`)
- **Script**: `scripts/unite_pnrr.py` (richiede `TOOLKIT_ALLOW_SCRIPT_SOURCE=1`)
- **Copertura**: 2019–2025 "Intero anno" + **2026 "Primo semestre"** (dato parziale)
- **Grano**: anno × periodo × materia × tipo_ufficio × distretto × sede (~2.7k righe)

## Colonne target (solo civili)

| Colonna | Significato |
|---|---|
| `arretrato` | pendenti oltre 1 anno (definizione ministero) |
| `baseline_obiettivo_2024/2026` | dimensione del **cohort** di riferimento (costante per sede): pendenti al 31/12/2019 iscritti fino al 2016/2017 per il 2024; pendenti al 31/12/2022 iscritti dal 2017 per il 2026 |
| `pendenti_obiettivo_2024/2026` | quanti di quel cohort sono **ancora pendenti** nell'anno di riga (serie storica del progresso) |

Target ufficiali (M1C1, dopo revisione UE): **-95%** sul cohort 2024 entro 31/12/2024 (raggiunto) e **-90%** sul cohort 2026 entro 30/06/2026, cioè residuo ≤ 5% / ≤ 10% della baseline. Non sono target sulla pendenza totale.

## Caveat

- **2026 è solo Primo semestre** — non confrontabile 1:1 con gli anni interi; usare `periodo` nei filtri
- Le baseline si ripetono ogni anno per sede: sono costanti di policy, non valori osservati
- Cassazione: 8 righe/periodo, nazionali (distretto/sede vuoti)
- La nota metodologica PDF del portal spiega il calcolo dei target — da citare se si pubblicano claim sul raggiungimento

## Marts

- `monitoraggio_pnrr_giustizia`: grano pieno + delta pendenti dal 2019
- `mart_nazionale_trend`: aggregato nazionale per materia × tipo_ufficio
