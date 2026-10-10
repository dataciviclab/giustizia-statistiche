-- Mart mart_nazionale_trend: totale UCP istituiti per anno (nazionale)
-- e per tipo ufficio.

SELECT
    anno,
    ufficio,
    SUM(num_ucp_istituiti) AS ucp_istituiti,
    COUNT(DISTINCT sede) AS sedi_con_ucp
FROM clean_input
GROUP BY anno, ufficio
ORDER BY ufficio, anno
