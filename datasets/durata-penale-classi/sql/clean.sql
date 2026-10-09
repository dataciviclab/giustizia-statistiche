-- clean.sql: Durate penali per classi di tempo.
-- CSV export del foglio "Durate penali per classi" dell'XLSX Durata_penale.
-- Il file contiene ~967k righe di padding vuoto (artifact di export):
-- il filtro su anno scarta tutte.

SELECT
    normalize_string("Ufficio") AS ufficio,
    normalize_string("Distretto") AS distretto,
    normalize_string("Circondario/Sede") AS sede,
    normalize_string("Sezione ufficio") AS sezione_ufficio,
    normalize_string("Tempo di definizione") AS classe_tempo,
    cast_int("Anno") AS anno,
    cast_bigint("Definiti") AS definiti
FROM raw_input
WHERE cast_int("Anno") IS NOT NULL
