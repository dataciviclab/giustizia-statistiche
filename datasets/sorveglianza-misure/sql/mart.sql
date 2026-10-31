-- Mart sorveglianza_misure: provvedimenti annuali per distretto e misura.
-- Usa solo periodo_tipo = 'anno' per non duplicare i semestri.

SELECT
    anno,
    distretto,
    misura,
    SUM(provvedimenti) AS provvedimenti
FROM clean_input
WHERE periodo_tipo = 'anno'
GROUP BY anno, distretto, misura
ORDER BY anno, distretto, misura
