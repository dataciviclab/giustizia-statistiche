-- Compose quadro-distretto: 7 dataset MG a livello distretto (snapshot 2025).
--
-- raw_input = civile_flussi mart_summary (livello distretto) — la spina dorsale.
-- support penale_flussi via .clean (si aggrega qui); gli altri via .mart.<tabella>.
--
-- NOTE DI GRAIN:
-- - Indicatori: solo Tribunale (le Corti d'Appello hanno grano proprio).
-- - Spese: escluse le righe Nazionale/Interdistrettuale (voci reali ma non
--   distretti). Euro/procedimento = spesa distretto ÷ definiti civili.
-- - Durata classi: quota = somma delle classi 'oltre 2 anni' + 'oltre 3 anni'.
--   Le sezioni con classificazione a 4 mesi ('oltre 1 anno') NON sono
--   confrontabili e non sono conteggiate → quota sottostima il lungo.
-- - PNRR: solo Civile, Tribunale, Intero anno; i target sono presenti solo
--   per alcune sedi → somma dei target non nulli per distretto.

WITH civ AS (
    SELECT
        anno,
        distretto,
        sopravvenuti_totali AS civ_sopravvenuti,
        definiti_totali AS civ_definiti,
        pendenti_finali_totali AS civ_pendenti
    FROM raw_input
    WHERE livello_aggregazione = 'distretto'
      AND anno = 2025  -- snapshot: la spina definisce le righe del quadro
),
pen AS (
    SELECT
        anno,
        distretto,
        SUM(sopravvenuti) AS pen_sopravvenuti,
        SUM(definiti_totale) AS pen_definiti,
        SUM(pendenti_finali) AS pen_pendenti
    FROM read_parquet('{support.penale_flussi.clean}')
    GROUP BY anno, distretto
),
civ_ind AS (
    SELECT
        anno,
        distretto,
        clearance_rate_medio AS civ_clearance,
        disposition_time_medio AS civ_disposition_gg
    FROM read_parquet('{support.giustizia_civile_indicatori.mart.giustizia_civile_indicatori}')
    WHERE tipo_ufficio = 'Tribunale'
),
pen_ind AS (
    SELECT
        anno,
        distretto,
        clearance_rate_medio AS pen_clearance,
        disposition_time_medio AS pen_disposition_gg
    FROM read_parquet('{support.giustizia_penale_indicatori.mart.giustizia_penale_indicatori}')
    WHERE tipo_ufficio = 'Tribunale'
),
durata AS (
    SELECT
        anno,
        distretto,
        SUM(quota_pct) AS quota_penale_oltre_2anni
    FROM read_parquet('{support.durata_penale_classi.mart.mart_classi_sintesi}')
    WHERE ufficio = 'Tribunale'
      AND classe_tempo IN ('oltre 2 anni', 'oltre 3 anni')
    GROUP BY anno, distretto
),
spesa AS (
    SELECT
        anno,
        distretto,
        SUM(importo_totale) AS spesa_totale
    FROM read_parquet('{support.spese_giustizia.mart.spese_giustizia}')
    WHERE distretto NOT IN ('Nazionale', 'Interdistrettuale')
    GROUP BY anno, distretto
),
pnrr AS (
    SELECT
        anno,
        distretto,
        SUM(pendenti_fine_periodo) AS pnrr_pendenti,
        SUM(pendenti_obiettivo_2026) AS pnrr_target_2026
    FROM read_parquet('{support.monitoraggio_pnrr_giustizia.mart.monitoraggio_pnrr_giustizia}')
    WHERE materia = 'Civile'
      AND tipo_ufficio = 'Tribunale'
      AND periodo = 'Intero anno'
    GROUP BY anno, distretto
)
SELECT
    c.anno,
    c.distretto,
    c.civ_sopravvenuti,
    c.civ_definiti,
    c.civ_pendenti,
    p.pen_sopravvenuti,
    p.pen_definiti,
    p.pen_pendenti,
    ci.civ_clearance,
    ci.civ_disposition_gg,
    pi.pen_clearance,
    pi.pen_disposition_gg,
    d.quota_penale_oltre_2anni,
    s.spesa_totale,
    pn.pnrr_pendenti,
    pn.pnrr_target_2026
FROM civ c
LEFT JOIN pen p ON c.anno = p.anno AND c.distretto = p.distretto
LEFT JOIN civ_ind ci ON c.anno = ci.anno AND c.distretto = ci.distretto
LEFT JOIN pen_ind pi ON c.anno = pi.anno AND c.distretto = pi.distretto
LEFT JOIN durata d ON c.anno = d.anno AND c.distretto = d.distretto
LEFT JOIN spesa s ON c.anno = s.anno AND c.distretto = s.distretto
LEFT JOIN pnrr pn ON c.anno = pn.anno AND c.distretto = pn.distretto
ORDER BY c.distretto
