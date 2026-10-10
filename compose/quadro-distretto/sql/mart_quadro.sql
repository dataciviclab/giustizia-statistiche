-- Mart mart_quadro: clean + indicatori derivati
-- (euro per procedimento civile, scarto PNRR vs target 2026).

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
    pnrr_target_2026,
    (pnrr_pendenti - pnrr_target_2026) AS pnrr_scarto_vs_target,
    ROUND(pnrr_pendenti * 100.0 / NULLIF(pnrr_target_2026, 0), 0) AS pnrr_pct_target
FROM clean_input
ORDER BY distretto
