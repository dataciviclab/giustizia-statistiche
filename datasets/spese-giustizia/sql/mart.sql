-- Mart spese_giustizia: importo totale per anno, distretto e tipo di spesa.

SELECT
    anno,
    distretto,
    tipo_spesa,
    COUNT(*) AS n_voci,
    COUNT(DISTINCT dettaglio_tipo_spesa) AS n_dettagli,
    SUM(importo) AS importo_totale
FROM clean_input
GROUP BY anno, distretto, tipo_spesa
ORDER BY anno, distretto, tipo_spesa
