-- Mart mart_classi_sintesi: quota percentuale di definiti per classe di tempo,
-- aggregata per anno × distretto × ufficio. Risponde a: "quanti procedimenti
-- penali restano oltre 2 anni in un distretto?"

WITH tot_anno AS (
    SELECT
        anno,
        distretto,
        ufficio,
        SUM(definiti) AS totale_definiti
    FROM clean_input
    GROUP BY anno, distretto, ufficio
)
SELECT
    c.anno,
    c.distretto,
    c.ufficio,
    c.classe_tempo,
    SUM(c.definiti) AS definiti,
    t.totale_definiti,
    ROUND(SUM(c.definiti) * 100.0 / NULLIF(t.totale_definiti, 0), 2) AS quota_pct
FROM clean_input c
JOIN tot_anno t
    ON c.anno = t.anno AND c.distretto = t.distretto AND c.ufficio = t.ufficio
GROUP BY c.anno, c.distretto, c.ufficio, c.classe_tempo, t.totale_definiti
ORDER BY c.anno, c.distretto, c.ufficio, c.classe_tempo
