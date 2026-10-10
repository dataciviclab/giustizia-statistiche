-- Mart mart_nazionale: riga sintetica nazionale dal quadro distretti.
-- Le medie dei clearance sono pesate sui definiti; la quota penale
-- oltre 2 anni è pesata sui definiti penali. PNRR: somma dei cohort.

SELECT
    anno,
    'Italia' AS distretto,
    SUM(civ_sopravvenuti) AS civ_sopravvenuti,
    SUM(civ_definiti) AS civ_definiti,
    SUM(civ_pendenti) AS civ_pendenti,
    SUM(pen_sopravvenuti) AS pen_sopravvenuti,
    SUM(pen_definiti) AS pen_definiti,
    SUM(pen_pendenti) AS pen_pendenti,
    ROUND(SUM(civ_clearance * civ_definiti) / NULLIF(SUM(civ_definiti), 0), 3) AS civ_clearance,
    ROUND(SUM(civ_disposition_gg * civ_definiti) / NULLIF(SUM(civ_definiti), 0), 0) AS civ_disposition_gg,
    ROUND(SUM(pen_clearance * pen_definiti) / NULLIF(SUM(pen_definiti), 0), 3) AS pen_clearance,
    ROUND(SUM(pen_disposition_gg * pen_definiti) / NULLIF(SUM(pen_definiti), 0), 0) AS pen_disposition_gg,
    ROUND(SUM(quota_penale_oltre_2anni * pen_definiti) / NULLIF(SUM(pen_definiti), 0), 1) AS quota_penale_oltre_2anni,
    SUM(spesa_totale) AS spesa_totale,
    ROUND(SUM(spesa_totale) / NULLIF(SUM(civ_definiti), 0), 0) AS euro_per_procedimento_civ,
    SUM(pnrr_pendenti) AS pnrr_pendenti,
    SUM(pnrr_cohort_2026) AS pnrr_cohort_2026,
    SUM(pnrr_cohort_baseline_2026) AS pnrr_cohort_baseline_2026,
    ROUND(SUM(pnrr_cohort_2026) * 100.0 / NULLIF(SUM(pnrr_cohort_baseline_2026), 0), 1)
        AS pnrr_cohort_pct_residuo
FROM clean_input
GROUP BY anno
