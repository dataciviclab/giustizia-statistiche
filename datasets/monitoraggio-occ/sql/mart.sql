-- Mart monitoraggio_occ: grano pieno (anno × macro_area × distretto × tipologia)
-- con delta pendenti e clearance implicita.

SELECT
    anno,
    macro_area,
    distretto,
    tipologia_procedimento,
    pendenti_iniziali,
    iscritti,
    aperte,
    definiti,
    rinuncia,
    chiuse_per_rinuncia,
    definiti_istanze_non_ammissibili,
    definiti_diniego_omologazione,
    definiti_sentenza_omologazione,
    definiti_sentenza_ammissione,
    chiuse_accolte,
    chiuse_rigettate,
    pendenti_finali,
    (pendenti_finali - pendenti_iniziali) AS delta_pendenti,
    ROUND(definiti * 1.0 / NULLIF(iscritti, 0), 3) AS clearance_rate
FROM clean_input
ORDER BY anno, macro_area, distretto, tipologia_procedimento
