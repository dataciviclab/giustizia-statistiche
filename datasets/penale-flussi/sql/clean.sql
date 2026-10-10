-- clean.sql — Penale Flussi: iscritti, definiti, pendenti per ufficio penale
-- Fonte: Ministero della Giustizia — DG Statistica (PenaleFlussi20142025.xlsx, sheet "Data")
-- V0: solo file principale 2014-2025

SELECT
    cast_int("Anno") AS anno,
    normalize_string("Ufficio") AS tipo_ufficio,
    normalize_string("Sezione") AS sezione,
    normalize_string("Distretto") AS distretto,
    -- Bolzano/Bozen (fonte) → Bolzano: canone con civile_flussi e gli altri dataset
    CASE WHEN normalize_string("Circondario/Sede") = 'Bolzano/Bozen' THEN 'Bolzano'
         ELSE normalize_string("Circondario/Sede") END AS sede,
    cast_int("Sopravvenuti") AS sopravvenuti,
    cast_int("Definiti") AS definiti_totale,
    cast_int("Pendenti Finali") AS pendenti_finali
FROM raw_input
WHERE cast_int("Anno") IS NOT NULL
