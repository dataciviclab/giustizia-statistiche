-- Mart mart_nazionale_trend: aggregato nazionale per anno e tipologia.
-- Somma tutte le righe (incluse le spezzature di macro-area dei distretti).

SELECT
    anno,
    tipologia_procedimento,
    SUM(pendenti_iniziali) AS pendenti_iniziali,
    SUM(iscritti) AS iscritti,
    SUM(definiti) AS definiti,
    SUM(pendenti_finali) AS pendenti_finali,
    ROUND(SUM(definiti) * 1.0 / NULLIF(SUM(iscritti), 0), 3) AS clearance_rate,
    ROUND((SUM(pendenti_finali) - SUM(pendenti_iniziali)) * 100.0
        / NULLIF(SUM(pendenti_iniziali), 0), 1) AS delta_pendenti_pct
FROM clean_input
GROUP BY anno, tipologia_procedimento
ORDER BY tipologia_procedimento, anno
