-- Mart mediazione_civile: grano pieno + tasso di accordo.
-- Il tasso di accordo è calcolato sulle sole mediazioni con aderente comparso
-- (accordo raggiunto + non raggiunto), non sugli iscritti.

SELECT
    anno,
    semestre,
    distretto,
    tipologia_organismo,
    natura,
    pendenti_iniziali,
    iscritti,
    mancata_comparizione,
    accordo_raggiunto,
    accordo_non_raggiunto,
    totale_definiti,
    pendenti_finali,
    ROUND(
        accordo_raggiunto * 1.0 / NULLIF(accordo_raggiunto + accordo_non_raggiunto, 0),
        3
    ) AS tasso_accordo
FROM clean_input
ORDER BY anno, semestre, distretto, tipologia_organismo, natura
