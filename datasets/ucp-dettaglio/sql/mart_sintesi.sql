-- Mart mart_sintesi: per sede × anno — quanti UCP e quante risorse.
-- Le somme del personale sono su base UCP: un procuratore assegnato a
-- due UCP della stessa sede viene contato due volte (come da fonte).

SELECT
    anno,
    corte_appello,
    sede,
    COUNT(*) AS n_ucp,
    SUM(us_num) AS tot_us_gestite,
    SUM(pr_pagg_spr_supp) AS tot_procuratori,
    SUM(pers_amm_ass) AS tot_personale_amm,
    SUM(vpo_ass) AS tot_vpo,
    SUM(tiroc_art73) AS tot_tirocini_art73,
    SUM(borse_studio) AS tot_borse_studio
FROM clean_input
GROUP BY anno, corte_appello, sede
ORDER BY anno, corte_appello, sede
