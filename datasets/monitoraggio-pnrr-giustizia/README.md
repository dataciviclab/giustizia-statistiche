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
| `baseline_obiettivo_2024/2026` | costante di riferimento per sede (NON serie storica) |
| `pendenti_obiettivo_2024/2026` | soglia target per sede |

Il penale non ha target né arretrato nel file.

## Caveat

- **2026 è solo Primo semestre** — non confrontabile 1:1 con gli anni interi; usare `periodo` nei filtri
- Le baseline si ripetono ogni anno per sede: sono costanti di policy, non valori osservati
- Cassazione: 8 righe/periodo, nazionali (distretto/sede vuoti)
- La nota metodologica PDF del portal spiega il calcolo dei target — da citare se si pubblicano claim sul raggiungimento

## Marts

- `monitoraggio_pnrr_giustizia`: grano pieno + delta pendenti dal 2019
- `mart_nazionale_trend`: aggregato nazionale per materia × tipo_ufficio
