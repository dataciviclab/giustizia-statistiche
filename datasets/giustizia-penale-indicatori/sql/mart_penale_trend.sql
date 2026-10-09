-- mart_penale_trend — Clearance rate: multi-year trend per distretto/tipo_ufficio.
--
-- One row per (distretto, tipo_ufficio). Aggrega per distretto (AVG sulle sedi)
-- poi calcola CAGR su clearance rate medio.

WITH yearly_distretto AS (
    SELECT
        distretto,
        tipo_ufficio,
        anno,
        AVG(clearance_rate) AS clearance_rate_medio,
        AVG(disposition_time_gg) AS disposition_time_medio
    FROM clean_input
    WHERE clearance_rate IS NOT NULL
    GROUP BY distretto, tipo_ufficio, anno
),
per_group AS (
    SELECT
        distretto,
        tipo_ufficio,
        MIN(anno) AS first_year,
        MAX(anno) AS last_year
    FROM yearly_distretto
    GROUP BY distretto, tipo_ufficio
),
first_vals AS (
    SELECT y.distretto, y.tipo_ufficio, y.clearance_rate_medio AS first_cr, y.disposition_time_medio AS first_dt
    FROM yearly_distretto y
    JOIN per_group pg ON y.distretto = pg.distretto AND y.tipo_ufficio = pg.tipo_ufficio AND y.anno = pg.first_year
),
last_vals AS (
    SELECT y.distretto, y.tipo_ufficio, y.clearance_rate_medio AS last_cr, y.disposition_time_medio AS last_dt
    FROM yearly_distretto y
    JOIN per_group pg ON y.distretto = pg.distretto AND y.tipo_ufficio = pg.tipo_ufficio AND y.anno = pg.last_year
)
SELECT
    pg.distretto,
    pg.tipo_ufficio,
    pg.first_year,
    pg.last_year,
    (pg.last_year - pg.first_year) AS years_observed,
    fv.first_cr,
    lv.last_cr,
    ROUND(lv.last_cr - fv.first_cr, 3) AS delta_cr_abs,
    ROUND((lv.last_cr / NULLIF(fv.first_cr, 0) - 1) * 100, 1) AS delta_cr_pct,
    CASE
        WHEN pg.last_year > pg.first_year AND fv.first_cr > 0
        THEN ROUND((POWER(lv.last_cr / fv.first_cr, 1.0 / (pg.last_year - pg.first_year)) - 1) * 100, 3)
        ELSE NULL
    END AS cagr_cr_pct,
    fv.first_dt,
    lv.last_dt,
    ROUND(lv.last_dt - fv.first_dt, 1) AS delta_dt_abs
FROM per_group pg
JOIN first_vals fv ON pg.distretto = fv.distretto AND pg.tipo_ufficio = fv.tipo_ufficio
JOIN last_vals lv ON pg.distretto = lv.distretto AND pg.tipo_ufficio = lv.tipo_ufficio
ORDER BY pg.distretto, pg.tipo_ufficio
