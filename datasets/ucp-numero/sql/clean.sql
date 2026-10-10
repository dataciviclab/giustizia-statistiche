-- clean.sql: UCP — numero di unità casi procedimenti istituite per sede e anno.
-- La fonte usa "Anno 2021" → estrae l'anno numerico. Stato è sempre
-- "Convalidato" (colonna mantenuta per traceability).
-- Corte/Sede in fonte UPPERCASE → title-case (DuckDB non ha initcap:
-- list comprehension + CASE per FORLI'/L'AQUILA che perdono l'accento).

WITH raw AS (
    SELECT
        normalize_string("Ufficio") AS ufficio,
        normalize_string("Corte di Appello") AS corte_appello_raw,
        normalize_string("Sede") AS sede_raw,
        "Anno" AS anno_raw,
        normalize_string("Stato") AS stato,
        cast_int("NumUcpIstituiti") AS num_ucp_istituiti
    FROM raw_input
)
SELECT
    ufficio,
    CASE upper(corte_appello_raw)
        WHEN 'ANCONA' THEN 'Ancona'
        WHEN 'BARI' THEN 'Bari'
        WHEN 'BOLOGNA' THEN 'Bologna'
        WHEN 'BRESCIA' THEN 'Brescia'
        WHEN 'CAGLIARI' THEN 'Cagliari'
        WHEN 'CALTANISSETTA' THEN 'Caltanissetta'
        WHEN 'CAMPOBASSO' THEN 'Campobasso'
        WHEN 'CATANIA' THEN 'Catania'
        WHEN 'CATANZARO' THEN 'Catanzaro'
        WHEN 'FIRENZE' THEN 'Firenze'
        WHEN 'GENOVA' THEN 'Genova'
        WHEN 'L''AQUILA' THEN 'L''Aquila'
        WHEN 'LECCE' THEN 'Lecce'
        WHEN 'MESSINA' THEN 'Messina'
        WHEN 'MILANO' THEN 'Milano'
        WHEN 'NAPOLI' THEN 'Napoli'
        WHEN 'PALERMO' THEN 'Palermo'
        WHEN 'PERUGIA' THEN 'Perugia'
        WHEN 'POTENZA' THEN 'Potenza'
        WHEN 'REGGIO CALABRIA' THEN 'Reggio Calabria'
        WHEN 'ROMA' THEN 'Roma'
        WHEN 'SALERNO' THEN 'Salerno'
        WHEN 'TORINO' THEN 'Torino'
        WHEN 'TRENTO' THEN 'Trento'
        WHEN 'TRIESTE' THEN 'Trieste'
        WHEN 'VENEZIA' THEN 'Venezia'
        ELSE corte_appello_raw
    END AS corte_appello,
    CASE
        WHEN upper(sede_raw) = 'FORLI''' THEN 'Forlì'
        WHEN upper(sede_raw) = 'L''AQUILA' THEN 'L''Aquila'
        ELSE array_to_string([
            upper(substr(word, 1, 1)) || substr(word, 2)
            for word in string_split(lower(sede_raw), ' ')
        ], ' ')
    END AS sede,
    cast_int(regexp_extract(anno_raw, '(\d{4})', 1)) AS anno,
    stato,
    num_ucp_istituiti
FROM raw
WHERE cast_int(regexp_extract(anno_raw, '(\d{4})', 1)) IS NOT NULL
