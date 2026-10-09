-- Mart durata_civile: durata media pesata per anno, registro, distretto, sede, materia.
-- Solo livello Circondariale (base) — i rollup Distrettuale/Nazionale sono esclusi
-- per evitare doppi conteggi; la media è pesata per i definiti.

SELECT
    anno,
    registro,
    distretto,
    sede,
    materia,
    SUM(definiti) AS definiti,
    -- media pesata: sum(durata*definiti)/sum(definiti)
    ROUND(SUM(durata_media_gg * definiti) / NULLIF(SUM(definiti), 0), 1) AS durata_media_gg
FROM clean_input
WHERE livello_aggregazione = 'Circondariale'
  AND durata_media_gg IS NOT NULL
GROUP BY anno, registro, distretto, sede, materia
ORDER BY anno, registro, distretto, sede
