 
 -- CENSIMENTO SWIFT
 
INSERT INTO GAGT_SPORBANC ("COD_SPOR","DES_SPOR","COD_SOGGETTO","COD_ABI","COD_CAB","COD_TELEFONO","DES_SIGLA","COD_CAB_COMU","COD_PROV_SPOR","DES_COMU_SPOR","DES_INDI_SPOR","COD_CAP_SPOR","COD_NAZI","DAT_FINE_VALI","COD_SWIFT","COD_ENTE_MODI","COD_ENTE_CENS","DAT_CENS","TIM_STAT","COD_ABI_PREC","COD_CAB_PREC","COD_CIN_ABI","COD_CIN_CAB","COD_ABI_AUI","COD_NAZI_AUI","FLG_BONI_URGE","DES_RID_SPOR")
VALUES ('CITIFRPP','CITIBANK EUROPE PLC FRANCE BRANCH',null,null,null,null,null,null,null,'PARIS','21-25 RUE BALZAC',null,'029',null,'CITIFRPP','QUERY','QUERY',20240318,{ts '2024-03-18 09:48:54.137640'},null,null,null,null,null,null,'N',null);
 
 
-- riferimento
select * from GAGT_SPORBANC
where COD_SWIFT is not null
order by TIM_STAT
 
-- rif codice nazione
select * from GDET_CTBNAZIO
 
 
-- dati da modificare
/*
codice swift
nome filiale
comune
indirizzo
codice nazione 
data
*/