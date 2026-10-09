-- Mart mart_nazionale_trend: serie storica nazionale per tipo di spesa.
-- Livello nazionale = somma di tutti i distretti (incluse le righe NAZIONALE /
-- INTERDISTRETTUALE del 2025, che sono voci reali e non totali).

WITH per_anno_tipo AS (
    SELECT
        anno,
        tipo_spesa,
        SUM(importo) AS importo_totale
    FROM clean_input
    GROUP BY anno, tipo_spesa
),
totale_anno AS (
    SELECT
        anno,
        SUM(importo_totale) AS importo_anno
    FROM per_anno_tipo
    GROUP BY anno
)
SELECT
    p.anno,
    p.tipo_spesa,
    p.importo_totale,
    ROUND(p.importo_totale / NULLIF(t.importo_anno, 0) * 100, 2) AS quota_pct_anno
FROM per_anno_tipo p
JOIN totale_anno t ON p.anno = t.anno
ORDER BY p.anno, p.tipo_spesa
