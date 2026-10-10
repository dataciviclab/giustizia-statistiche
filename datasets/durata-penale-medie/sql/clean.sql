-- clean.sql: Durate medie penali per dettaglio territoriale.
-- CSV export del foglio "Durate medie penali" — 3 grani in un file:
--   Nazione (132 righe/anno), Distretto, Sede (~13k). Il campo
--   dettaglio_territoriale discrimina; ~1M righe di padding scartate.

SELECT
    normalize_string("Dettaglio territoriale") AS dettaglio_territoriale,
    normalize_string("Ufficio") AS ufficio,
    normalize_string("Distretto") AS distretto,
    -- Bolzano/Bozen (fonte) → Bolzano: canone con i dataset civili
    CASE WHEN normalize_string("Circondario/Sede") = 'Bolzano/Bozen' THEN 'Bolzano'
         ELSE normalize_string("Circondario/Sede") END AS sede,
    normalize_string("Sezione ufficio") AS sezione_ufficio,
    cast_int("Anno") AS anno,
    cast_double("Durata media in giorni") AS durata_media_gg
FROM raw_input
WHERE cast_int("Anno") IS NOT NULL
  AND cast_double("Durata media in giorni") IS NOT NULL
