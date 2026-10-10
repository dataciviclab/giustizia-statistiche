-- clean.sql: Monitoraggio OCC — crisi di sovraindebitamento per distretto.
-- CSV ministeriale con 17 colonne; le colonne di esito (omologazione,
-- rinuncia, apertura procedure) sono valorizzate solo per alcune tipologie
-- (null strutturali, non errori). Genova compare su Nord e Centro.

SELECT
    cast_int("Anno") AS anno,
    normalize_string("Macro Area Geografica") AS macro_area,
    normalize_string("Distretto") AS distretto,
    normalize_string("Tipologia Procedimento") AS tipologia_procedimento,
    cast_bigint("Pendenti Iniziali") AS pendenti_iniziali,
    cast_bigint("Iscritti") AS iscritti,
    cast_bigint("Aperte") AS aperte,
    cast_bigint("Definiti") AS definiti,
    cast_bigint("Rinuncia") AS rinuncia,
    cast_bigint("Chiuse Per Rinuncia") AS chiuse_per_rinuncia,
    cast_bigint("Definiti Istanze Non Ammissibili") AS definiti_istanze_non_ammissibili,
    cast_bigint("Definiti Diniego Omologazione") AS definiti_diniego_omologazione,
    cast_bigint("Definiti Sentenza Omologazione") AS definiti_sentenza_omologazione,
    cast_bigint("Definiti Sentenza Ammissione") AS definiti_sentenza_ammissione,
    cast_bigint("Chiuse Accolte") AS chiuse_accolte,
    cast_bigint("Chiuse Rigettate") AS chiuse_rigettate,
    cast_bigint("Pendenti Finali") AS pendenti_finali
FROM raw_input
WHERE cast_int("Anno") IS NOT NULL
