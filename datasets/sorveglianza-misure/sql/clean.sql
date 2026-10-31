-- clean.sql — Sorveglianza: provvedimenti per misura, ufficio, sede
-- Fonte: DGSTAT — Sorveglianza_misure_dati.csv (delimitatore ';', UTF-8 BOM)
--
-- ATTENZIONE: "Semestre" contiene 'Primo semestre', 'Secondo semestre' E 'Anno'.
-- La riga 'Anno' è il totale annuale ufficiale, duplicato dei due semestri.
-- Le righe sono mantenute entrambe e distinte da periodo_tipo:
--   periodo_tipo = 'semestre'  -> semestre 1 o 2
--   periodo_tipo = 'anno'      -> totale annuale (semestre NULL)
-- Sommare provvedimenti senza filtrare periodo_tipo raddoppia i totali.

SELECT
    cast_int("Anno") AS anno,
    CASE lower(normalize_string("Semestre"))
        WHEN 'anno' THEN 'anno'
        ELSE 'semestre'
    END AS periodo_tipo,
    CASE lower(normalize_string("Semestre"))
        WHEN 'primo semestre'   THEN 1
        WHEN 'secondo semestre' THEN 2
        ELSE NULL
    END AS semestre,
    normalize_string("Tipo ufficio") AS tipo_ufficio,
    normalize_string("Distretto") AS distretto,
    -- Bolzano/Bozen (fonte) → Bolzano: canone con penale_flussi, civile_flussi e gli altri dataset
    CASE WHEN normalize_string("Sede") = 'Bolzano/Bozen' THEN 'Bolzano'
         ELSE normalize_string("Sede") END AS sede,
    normalize_string("Misura") AS misura,
    normalize_string("Oggetto") AS oggetto,
    -- Natura della misura: la stessa mappa vive in sorveglianza-esecuzione/sql/clean.sql.
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
