-- Mart mart_nazionale_trend: durata media nazionale per anno, registro e materia.
-- Usa le righe di livello Nazionale dove presenti; dove mancanti (SIECIC
-- Circondariale-only per alcune materie) calcola dai circondari pesando per definiti.

WITH nazionale_pubblicato AS (
    SELECT
        anno,
        registro,
        materia,
        SUM(definiti) AS definiti,
        SUM(durata_media_gg * definiti) / NULLIF(SUM(definiti), 0) AS durata_media_gg
    FROM clean_input
    WHERE livello_aggregazione = 'Nazionale'
      AND durata_media_gg IS NOT NULL
    GROUP BY anno, registro, materia
),
circondariale_agg AS (
    SELECT
        anno,
        registro,
        materia,
        SUM(definiti) AS definiti,
        SUM(durata_media_gg * definiti) / NULLIF(SUM(definiti), 0) AS durata_media_gg
    FROM clean_input
    WHERE livello_aggregazione = 'Circondariale'
      AND durata_media_gg IS NOT NULL
    GROUP BY anno, registro, materia
)
SELECT
    anno,
    registro,
    materia,
    ROUND(definiti, 0) AS definiti,
    ROUND(durata_media_gg, 1) AS durata_media_gg,
    'pubblicato' AS origine
FROM nazionale_pubblicato
UNION ALL
SELECT
    c.anno,
    c.registro,
    c.materia,
    ROUND(c.definiti, 0) AS definiti,
    ROUND(c.durata_media_gg, 1) AS durata_media_gg,
    'calcolato_da_circondari' AS origine
FROM circondariale_agg c
LEFT JOIN nazionale_pubblicato n
    ON c.anno = n.anno AND c.registro = n.registro AND c.materia = n.materia
WHERE n.materia IS NULL
ORDER BY anno, registro, materia
