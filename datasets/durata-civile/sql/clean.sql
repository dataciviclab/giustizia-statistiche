-- clean.sql: Durata procedimenti civili — SICID (ordinario) + SIECIC (esecuzioni).
-- Unite dallo script unite_durata_civile.py: le colonne arrivano già snake_case.
-- NOTA: i 3 livelli di aggregazione (Circondariale/Distrettuale/Nazionale)
-- sono ROLLUP della stessa realtà: nei marts usare solo Circondariale
-- per evitare doppi conteggi nei SUM; le medie sono pesate da definiti.

SELECT
    registro,
    ripartizione,
    distretto,
    tipo_ufficio,
    sede,
    livello_aggregazione,
    materia,
    cast_int(anno) AS anno,
    cast_bigint(definiti) AS definiti,
    cast_double(durata_media_gg) AS durata_media_gg
FROM raw_input
WHERE cast_int(anno) IS NOT NULL
  AND coalesce(sede, '') <> ''
