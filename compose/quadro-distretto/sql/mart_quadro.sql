-- Mart mart_quadro: clean + indicatori derivati.
-- PNRR: il target (-90% entro 06/2026) riguarda il cohort dei vecchi
-- arretrati (pendenti al 2022, iscritti 2017-2022), non la pendenza totale.
--   pct_residuo = cohort corrente / baseline × 100 (target: ≤ 10)
--   sotto_target = cohort corrente ≤ baseline × 0.10

SELECT
    anno,
    distretto,
    civ_sopravvenuti,
    civ_definiti,
    civ_pendenti,
    pen_sopravvenuti,
    pen_definiti,
    pen_pendenti,
    civ_clearance,
    civ_disposition_gg,
    pen_clearance,
    pen_disposition_gg,
    quota_penale_oltre_2anni,
    spesa_totale,
    ROUND(spesa_totale / NULLIF(civ_definiti, 0), 0) AS euro_per_procedimento_civ,
    pnrr_pendenti,
    pnrr_cohort_2026,
    pnrr_cohort_baseline_2026,
    ROUND(pnrr_cohort_2026 * 100.0 / NULLIF(pnrr_cohort_baseline_2026, 0), 1)
        AS pnrr_cohort_pct_residuo,
    (pnrr_cohort_2026 <= pnrr_cohort_baseline_2026 * 0.10) AS pnrr_sotto_target_2026
FROM clean_input
ORDER BY distretto
