-- clean.sql: Giustizia civile — clearance rate e disposition time.
-- 3 sheet unificati dallo script unite_sheets_civili.py:
--   Tribunali e Corti d'Appello (2014-2025, con Fonte SICID|SIECIC),
--   Giudici di Pace (2023-2025), Tribunali per i Minorenni (2023-2025, senza Distretto).
-- Righe senza clearance_rate scartate (stesso filtro del penale).

SELECT
    cast_int("Anno") AS anno,
    normalize_string("Fonte") AS fonte,
    normalize_string("Tipo ufficio") AS tipo_ufficio,
    normalize_string("Distretto") AS distretto,
    CASE WHEN normalize_string("Sede") = 'Bolzano/Bozen' THEN 'Bolzano'
         ELSE normalize_string("Sede") END AS sede,
    normalize_string("Macromateria") AS macromateria,
    normalize_string("Materia") AS materia,
    cast_double("Clearance rate") AS clearance_rate,
    cast_double("Disposition time") AS disposition_time_gg
FROM raw_input
WHERE cast_int("Anno") IS NOT NULL
  AND cast_double("Clearance rate") IS NOT NULL
