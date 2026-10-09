-- Mart durata_penale_medie: passthrough con ordinamento stabile.
-- Il clean ha già il grano analitico (anno × dettaglio × ufficio × sede × sezione);
-- il mart espone solo le righe con sede valorizzata (livello Sede) più le
-- righe Nazionale per il trend — esclude Distretto se non serve.

SELECT
    anno,
    dettaglio_territoriale,
    ufficio,
    distretto,
    sede,
    sezione_ufficio,
    durata_media_gg
FROM clean_input
WHERE dettaglio_territoriale IN ('Nazione', 'Sede')
   OR sede IS NOT NULL
ORDER BY anno, dettaglio_territoriale, ufficio, distretto, sede, sezione_ufficio
