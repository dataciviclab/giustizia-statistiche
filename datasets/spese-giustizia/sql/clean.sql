-- clean.sql: Spese di giustizia — importi liquidati dall'erario per ufficio giudiziario.
--
-- Colonne raw: Anno (stringa), Distretto, Tipo di Spesa, Dettaglio Tipo Spesa, Importo (double).
-- 26 distretti 2014-2024; dal 2025 compaiono anche NAZIONALE e INTERDISTRETTUALE
-- (righe reali, non totali — non causano doppio conteggio nel mart).

select
  cast_int("Anno") as anno,
  -- CASE esplicito: DuckDB non ha initcap; dominio fisso (28 valori) allineato
  -- al case title usato dagli altri 10 dataset.
  CASE upper(normalize_string("Distretto"))
    WHEN 'ANCONA' THEN 'Ancona'
    WHEN 'BARI' THEN 'Bari'
    WHEN 'BOLOGNA' THEN 'Bologna'
    WHEN 'BRESCIA' THEN 'Brescia'
    WHEN 'CAGLIARI' THEN 'Cagliari'
    WHEN 'CALTANISSETTA' THEN 'Caltanissetta'
    WHEN 'CAMPOBASSO' THEN 'Campobasso'
    WHEN 'CATANIA' THEN 'Catania'
    WHEN 'CATANZARO' THEN 'Catanzaro'
    WHEN 'FIRENZE' THEN 'Firenze'
    WHEN 'GENOVA' THEN 'Genova'
    WHEN 'INTERDISTRETTUALE' THEN 'Interdistrettuale'
    WHEN 'L''AQUILA' THEN 'L''Aquila'
    WHEN 'LECCE' THEN 'Lecce'
    WHEN 'MESSINA' THEN 'Messina'
    WHEN 'MILANO' THEN 'Milano'
    WHEN 'NAPOLI' THEN 'Napoli'
    WHEN 'NAZIONALE' THEN 'Nazionale'
    WHEN 'PALERMO' THEN 'Palermo'
    WHEN 'PERUGIA' THEN 'Perugia'
    WHEN 'POTENZA' THEN 'Potenza'
    WHEN 'REGGIO CALABRIA' THEN 'Reggio Calabria'
    WHEN 'ROMA' THEN 'Roma'
    WHEN 'SALERNO' THEN 'Salerno'
    WHEN 'TORINO' THEN 'Torino'
    WHEN 'TRENTO' THEN 'Trento'
    WHEN 'TRIESTE' THEN 'Trieste'
    WHEN 'VENEZIA' THEN 'Venezia'
    ELSE normalize_string("Distretto")
  END as distretto,
  normalize_string("Tipo di Spesa") as tipo_spesa,
  normalize_string("Dettaglio Tipo Spesa") as dettaglio_tipo_spesa,
  cast_double("Importo") as importo
from raw_input
where cast_int("Anno") is not null
  and coalesce(normalize_string("Distretto"), '') <> ''
