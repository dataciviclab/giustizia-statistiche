-- Mart mart_nazionale_trend: serie nazionale definiti/pendenti per materia e
-- tipo ufficio (somma delle sedi + righe Cassazione che sono già nazionali).

SELECT
    anno,
    periodo,
    materia,
    tipo_ufficio,
    SUM(definiti) AS definiti,
    SUM(pendenti_fine_periodo) AS pendenti_fine_periodo,
    MIN(pendenti_20191231) AS pendenti_20191231_riferimento,
    -- clearance implicita: definiti / pendenti iniziali proxy
    ROUND(SUM(definiti) * 1.0 / NULLIF(SUM(pendenti_fine_periodo), 0), 3) AS rapporto_definiti_pendenti
FROM clean_input
GROUP BY anno, periodo, materia, tipo_ufficio
ORDER BY materia, tipo_ufficio, anno, periodo
