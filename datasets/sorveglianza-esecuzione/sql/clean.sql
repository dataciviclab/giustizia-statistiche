-- clean.sql — Sorveglianza: misure in esecuzione (flusso e stock)
-- Fonte: DGSTAT — Sorveglianza_misure_esecuzione_dati.csv (delimitatore ';', UTF-8 BOM)
--
-- "Tipologia" distingue:
--   'Aperte nel periodo'    -> flusso  (misure avviate nell'anno)
--   'Aperte a fine periodo' -> stock   (misure in essere al 31/12)
-- La colonna "Misura" è costante ('In esecuzione') e viene scartata.

SELECT
    cast_int("Anno") AS anno,
    CASE lower(normalize_string("Tipologia"))
        WHEN 'aperte a fine periodo' THEN 'stock'
        ELSE 'flusso'
    END AS tipologia,
    normalize_string("Tipo ufficio") AS tipo_ufficio,
    normalize_string("Distretto") AS distretto,
    -- Bolzano/Bozen (fonte) → Bolzano: canone con penale_flussi, civile_flussi e gli altri dataset
    CASE WHEN normalize_string("Sede") = 'Bolzano/Bozen' THEN 'Bolzano'
         ELSE normalize_string("Sede") END AS sede,
    normalize_string("Oggetto") AS oggetto,
    -- Natura della misura: la stessa mappa vive in sorveglianza-misure/sql/clean.sql.
    -- Se cambia qui, va cambiata là (nessun macro condiviso disponibile nel contratto clean).
    CASE
        WHEN lower(normalize_string("Oggetto")) LIKE '%arresti domiciliari%' THEN 'cautelare'
        WHEN lower(normalize_string("Oggetto")) LIKE '%libert%controllata%'
          OR lower(normalize_string("Oggetto")) LIKE '%semidetenzione%'
          OR lower(normalize_string("Oggetto")) LIKE '%lavoro sostitutivo%'
          OR lower(normalize_string("Oggetto")) LIKE '%espulsione%' THEN 'sostitutiva'
        WHEN lower(normalize_string("Oggetto")) LIKE '%affidamento%'
          OR lower(normalize_string("Oggetto")) LIKE '%lavoro esterno%'
          OR lower(normalize_string("Oggetto")) LIKE '%esecuzione presso domicilio%'
          OR lower(normalize_string("Oggetto")) LIKE '%detenzione domiciliare%'
          OR lower(normalize_string("Oggetto")) LIKE '%semilibert%'
          OR lower(normalize_string("Oggetto")) LIKE '%liberazione condizionale%'
          OR lower(normalize_string("Oggetto")) LIKE '%permanenza in casa%' THEN 'alternativa'
        ELSE 'altro'
    END AS natura_misura,
    cast_int("Provvedimenti") AS provvedimenti
FROM raw_input
WHERE cast_int("Anno") IS NOT NULL
