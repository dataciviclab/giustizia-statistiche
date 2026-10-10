-- Mart ucp_dettaglio: passthrough ordinato del censimento.
-- Colonne SAS-/SPM-/SAP- (attività e attività delegate) restano nel clean
-- come VARCHAR numeriche — qui non sono esposte: per l'analisi operativa
-- contano sede, personale e tipi di udienza (US).

SELECT
    anno,
    corte_appello,
    descrizione,
    sede,
    identificativo_ucp,
    us_num,
    supporto,
    us_segreteria_del_pm,
    us_dibattimento_mod_21,
    us_definizione_affari_seriali_semplici,
    us_spese_di_giustizia,
    us_affari_civili,
    us_dibattimento_mod_21_bis,
    us_impugnazioni,
    us_esecuzione_penale,
    us_trattazione_giudizio_direttissimo,
    us_convalide_di_arresto,
    pr_pagg_spr_supp,
    pers_amm_ass,
    vpo_ass,
    tiroc_art73,
    tiroc_art37,
    borse_studio
FROM clean_input
ORDER BY anno, corte_appello, sede, identificativo_ucp
