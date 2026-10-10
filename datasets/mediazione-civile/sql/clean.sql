-- clean.sql: Mediazione civile — flussi semestrali per organismo e natura.
-- CSV scaricato dallo script discover_flussi.py (URL rotante risolto dalla pagina).
-- Distretto UPPERCASE in fonte → CASE title-case (stesso canone degli altri dataset;
-- dominio = i 26 distretti, nessun aggregato nazionale in questo file).

SELECT
    cast_int("Anno") AS anno,
    normalize_string("Semestre") AS semestre,
    CASE upper(normalize_string("Distretto"))
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
        ELSE normalize_string("Distretto")
    END AS distretto,
    normalize_string("Tipologia organismo") AS tipologia_organismo,
    normalize_string("Natura") AS natura,
    cast_bigint("PENDENTI INIZIALI") AS pendenti_iniziali,
    cast_bigint("ISCRITTI") AS iscritti,
    cast_bigint("Mancata Comparizione aderente") AS mancata_comparizione,
    cast_bigint("Aderente comparso Accordo raggiunto") AS accordo_raggiunto,
    cast_bigint("Aderente comparso Accordo NON raggiunto") AS accordo_non_raggiunto,
    cast_bigint("Totale definiti") AS totale_definiti,
    cast_bigint("Pendenti finali") AS pendenti_finali
FROM raw_input
WHERE cast_int("Anno") IS NOT NULL
