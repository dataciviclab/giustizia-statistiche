-- Mart sorveglianza_esecuzione: stock e flusso per distretto, anno e natura della misura.

SELECT
    anno,
    distretto,
    tipologia,
    natura_misura,
    SUM(provvedimenti) AS provvedimenti
FROM clean_input
GROUP BY anno, distretto, tipologia, natura_misura
ORDER BY anno, distretto, tipologia, natura_misura
