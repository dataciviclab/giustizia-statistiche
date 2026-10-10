-- Mart ucp_numero: passthrough ordinato (grano sede × ufficio × anno).

SELECT
    anno,
    ufficio,
    corte_appello,
    sede,
    stato,
    num_ucp_istituiti
FROM clean_input
ORDER BY anno, corte_appello, sede, ufficio
