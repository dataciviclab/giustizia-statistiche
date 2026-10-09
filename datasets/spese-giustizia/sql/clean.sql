-- clean.sql: Spese di giustizia — importi liquidati dall'erario per ufficio giudiziario.
--
-- Colonne raw: Anno (stringa), Distretto, Tipo di Spesa, Dettaglio Tipo Spesa, Importo (double).
-- 26 distretti 2014-2024; dal 2025 compaiono anche NAZIONALE e INTERDISTRETTUALE
-- (righe reali, non totali — non causano doppio conteggio nel mart).

select
  cast_int("Anno") as anno,
  normalize_string("Distretto") as distretto,
  normalize_string("Tipo di Spesa") as tipo_spesa,
  normalize_string("Dettaglio Tipo Spesa") as dettaglio_tipo_spesa,
  cast_double("Importo") as importo
from raw_input
where cast_int("Anno") is not null
  and coalesce(normalize_string("Distretto"), '') <> ''
