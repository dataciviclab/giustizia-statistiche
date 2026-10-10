-- Clean layer: Giustizia penale - clearance rate e disposition time
-- 4 sheet unificati: Tribunali, Corti d'Appello, Giudici di Pace, Minorenni
-- Fonte: Ministero della Giustizia (Indicatori_Penali.xlsx)
-- Script: unite_sheets_penali.py scarica XLSX e unisce i 4 sheet in CSV

SELECT
    cast_int("Anno") AS anno,
    normalize_string("Tipo ufficio") AS tipo_ufficio,
    -- 3 sedi minorenni hanno la sede nel campo distretto (non sono distretti
    -- reali): riassegnate al distretto parente della Corte d'Appello.
    CASE normalize_string("Distretto")
        WHEN 'Bolzano/Bozen' THEN 'Trento'
        WHEN 'Sassari' THEN 'Cagliari'
        WHEN 'Taranto' THEN 'Lecce'
        ELSE normalize_string("Distretto")
    END AS distretto,
    CASE WHEN normalize_string("Sede") = 'Bolzano/Bozen' THEN 'Bolzano'
         ELSE normalize_string("Sede") END AS sede,
    normalize_string("Sezione") AS sezione,
    cast_double("Clearance rate") AS clearance_rate,
    cast_double("Disposition time") AS disposition_time_gg
FROM raw_input
WHERE cast_int("Anno") IS NOT NULL
  AND cast_double("Clearance rate") IS NOT NULL
