-- clean.sql: UCP dettaglio — censimento organizzativo per singola unità.
-- Lo script prepare_dettaglio.py sanifica header (snake_case) e tipi.
-- Qui: parse anno ("Anno 2021" → 2021), title-case sede, cast difensivi.

SELECT
    normalize_string("corte_di_appello") AS corte_appello,
    normalize_string("descrizione") AS descrizione,
    CASE
        WHEN upper(normalize_string("sede")) = 'FORLI''' THEN 'Forlì'
        WHEN upper(normalize_string("sede")) = 'L''AQUILA' THEN 'L''Aquila'
        ELSE array_to_string([
            upper(substr(word, 1, 1)) || substr(word, 2)
            for word in string_split(lower(normalize_string("sede")), ' ')
        ], ' ')
    END AS sede,
    cast_int(regexp_extract("anno", '(\d{4})', 1)) AS anno,
    cast_int("identificativo_ucp_istituito") AS identificativo_ucp,
    cast_int("usnum") AS us_num,
    normalize_string("supporto") AS supporto,
    -- US: tipi di udienza preparatoria gestita
    cast_int("us_segreteria_del_pm") AS us_segreteria_del_pm,
    cast_int("us_dibattimento_mod_21") AS us_dibattimento_mod_21,
    cast_int("us_definizione_affari_seriali_semplici") AS us_definizione_affari_seriali_semplici,
    cast_int("us_spese_di_giustizia") AS us_spese_di_giustizia,
    cast_int("us_affari_civili") AS us_affari_civili,
    cast_int("us_dibattimento_mod_21_bis") AS us_dibattimento_mod_21_bis,
    cast_int("us_impugnazioni") AS us_impugnazioni,
    cast_int("us_esecuzione_penale") AS us_esecuzione_penale,
    cast_int("us_trattazione_giudizio_direttissimo") AS us_trattazione_giudizio_direttissimo,
    cast_int("us_convalide_di_arresto") AS us_convalide_di_arresto,
    -- personale assegnato
    cast_int("pr_pagg_spr_supp") AS pr_pagg_spr_supp,
    cast_int("persammass") AS pers_amm_ass,
    cast_int("vpoass") AS vpo_ass,
    cast_int("tirocassart73") AS tiroc_art73,
    cast_int("tirocassart37") AS tiroc_art37,
    cast_int("borsestudio") AS borse_studio
FROM raw_input
WHERE cast_int(regexp_extract("anno", '(\d{4})', 1)) IS NOT NULL
