-- clean.sql: Monitoraggio PNRR giustizia — definiti e pendenti per sede.
-- Due CSV uniti dallo script unite_pnrr.py (materia = Civile | Penale).
-- Colonne target/arretrato valorizzate solo sui civili (null per il penale).
-- NB: le baseline obiettivo sono valori di riferimento ripetuti anno per anno
--     per sede, non una serie storica — vanno lette come costanti di policy.

SELECT
    normalize_string("materia") AS materia,
    cast_int("anno") AS anno,
    normalize_string("periodo") AS periodo,
    normalize_string("tipo_ufficio") AS tipo_ufficio,
    normalize_string("ripartizione") AS ripartizione,
    normalize_string("distretto") AS distretto,
    normalize_string("sede") AS sede,
    cast_bigint("definiti") AS definiti,
    cast_bigint("pendenti_fine_periodo") AS pendenti_fine_periodo,
    cast_bigint("pendenti_20191231") AS pendenti_20191231,
    cast_bigint("arretrato") AS arretrato,
    cast_bigint("baseline_obiettivo_2024") AS baseline_obiettivo_2024,
    cast_bigint("pendenti_obiettivo_2024") AS pendenti_obiettivo_2024,
    cast_bigint("baseline_obiettivo_2026") AS baseline_obiettivo_2026,
    cast_bigint("pendenti_obiettivo_2026") AS pendenti_obiettivo_2026
FROM raw_input
WHERE cast_int("anno") IS NOT NULL
  AND coalesce(normalize_string("materia"), '') <> ''
