-- Mart monitoraggio_pnrr_giustizia: grano pieno sede × anno × periodo × materia.
-- Espone anche lo scarto arretrato = pendenti - baseline 2019 (positivo = peggioramento).

SELECT
    anno,
    periodo,
    materia,
    tipo_ufficio,
    ripartizione,
    distretto,
    sede,
    definiti,
    pendenti_fine_periodo,
    pendenti_20191231,
    arretrato,
    (pendenti_fine_periodo - pendenti_20191231) AS delta_pendenti_dal_2019,
    baseline_obiettivo_2024,
    pendenti_obiettivo_2024,
    baseline_obiettivo_2026,
    pendenti_obiettivo_2026
FROM clean_input
ORDER BY anno, periodo, materia, tipo_ufficio, distretto, sede
