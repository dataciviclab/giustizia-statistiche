-- Mart durata_penale_classi: definiti per anno, ufficio, distretto, sede,
-- sezione e classe di tempo. Grano identico al clean (nessuna aggregazione):
-- utile come tabella di lavoro per quote e percentuali.

SELECT
    anno,
    ufficio,
    distretto,
    sede,
    sezione_ufficio,
    classe_tempo,
    SUM(definiti) AS definiti
FROM clean_input
GROUP BY anno, ufficio, distretto, sede, sezione_ufficio, classe_tempo
ORDER BY anno, distretto, sede, sezione_ufficio, classe_tempo
