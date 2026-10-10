-- Mart mart_nazionale_trend: aggregato nazionale per semestre e tipologia organismo.

SELECT
    anno,
    semestre,
    tipologia_organismo,
    SUM(pendenti_iniziali) AS pendenti_iniziali,
    SUM(iscritti) AS iscritti,
    SUM(mancata_comparizione) AS mancata_comparizione,
    SUM(accordo_raggiunto) AS accordo_raggiunto,
    SUM(accordo_non_raggiunto) AS accordo_non_raggiunto,
    SUM(totale_definiti) AS totale_definiti,
    SUM(pendenti_finali) AS pendenti_finali,
    ROUND(
        SUM(accordo_raggiunto) * 1.0
        / NULLIF(SUM(accordo_raggiunto) + SUM(accordo_non_raggiunto), 0),
        3
    ) AS tasso_accordo
FROM clean_input
GROUP BY anno, semestre, tipologia_organismo
ORDER BY tipologia_organismo, anno, semestre
