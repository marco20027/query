SET CURRENT SQLID = 'IGFP01' --settare ambiente fucino

--start g
SELECT COD_PROC, DAT_ELAB, TIM_END  FROM SCPR_ELABTIME
WHERE COD_PROC 
LIKE '%IGGPSP01%'
ORDER BY DAT_ELAB DESC, TIM_START DESC

--fine g
SELECT COD_PROC, DAT_ELAB, TIM_END  FROM SCPR_ELABTIME
WHERE COD_PROC  LIKE '%IGGPSP02%'
ORDER BY DAT_ELAB DESC, TIM_START DESC

--VERIFICARE CHE SIANO ARRIVATE LE MAIL DEI 5 FLUSSI DA CEDACRI (INTORNO ALLE 8) !!ATTENZIONE A VOLTE VANNO NELLA POSTA INDESIDERATA.

--FLUSSI VS CEDACRI (IF94 A VOLTE è VUOTO)
SELECT P.NUM_ID, P.COD_PROC, P.FLG_STAT, P.DES_FILE, D.TMS_CENS, D.TMS_SEND, D.DLV_STATUS
FROM SCPR_LOGPROC P, TCON_DLVQUEUE D
WHERE P.COD_PROC IN ('IGGPIF4R','IGGPIF19','IGGPIF94','IGGPAG82','IGGPAR53','IGGPIF93')
AND P.NUM_ID = D.NUM_ID
ORDER BY P.TMS_CENS DESC


SELECT * FROM SCPR_LOGPROC -- VERIFICA CHE NON CI SIANO KEYFLXML IN 9
WHERE COD_PROC LIKE '%LQ%'
AND COD_OUTP LIKE '%KEYFLXML%'
AND FLG_STAT <> '2'
ORDER BY TMS_CENS DESC --ASC nel caso si richiede il crescente

SELECT * FROM TCON_DLVQUEUE --VERIFICA CHE NON CI SIANO FLUSSI BONIFICI IN ERRORE
ORDER BY TMS_CENS DESC
 
--IGGPIF54 - Flusso giornaliero VM verso CEDACRI
SELECT P.NUM_ID, P.COD_PROC, P.FLG_STAT, P.DES_FILE, D.TMS_CENS, D.TMS_SEND, D.DLV_STATUS, P.COD_OUTP FROM SCPR_LOGPROC P, TCON_DLVQUEUE D
WHERE P.COD_PROC IN ('OBJFING')
AND P.NUM_ID = D.NUM_ID
ORDER BY P.TMS_CENS DESC


--CONTROLLARE CHE SIANO OK
SELECT * FROM SCPR_ELABTIME
WHERE COD_PROC IN ('IGGPIF54','IGGPIF64','IGMPIF54','IGMPIF64','IGMPIF55','IGMPIF65')
ORDER BY DAT_ELAB DESC

--SCARTI
SELECT * FROM FCGT_MOVIECBC
WHERE COD_STAT_MOVI = 'S'

--VERIFICA GENERICA ERRORI
SELECT * FROM SCPR_ELABTIME
WHERE DES_ESITO LIKE '%ERROR%'
ORDER BY DAT_ELAB DESC, TIM_START DESC

--VERIFICA GENERICA OUTPUT IN ERRORE
select * from scpr_logproc 
where (flg_stat in ('3') or (flg_stat ='1' and cod_outp<>'WEB'))   
and date(tms_cens) >= '2023-06-01'
order by num_id desc 

--2024/29
--estrazione con mappatura prodotto cedacri Pxx e prodotti K4F con relativa descrizione
SELECT A.COD_ORIG, B.DES_EST_LINEA_SIST, A.COD_DEST FROM GDET_DECODK4F A, GDET_CTBLSIST B
WHERE A.COD_ORIG = B.COD_LINEA_SISTEMA
AND A.COD_TIPO_DECF = 'LSTDS'
AND B.COD_LINEA_SISTEMA IN (211,'241','242','431','441','561','741','742','744','745')

-2024/31
--update sul filiale da 001 a 83 (cod_ente_azie)
MTA3MjA2

--2024/8
--estrazione di ndg codice esterno cedacri
select * from gagt_codieste -- tabella per codice cedacri

--2024/19
--estrazione per ndg e mettere in stato uno poi lo portano in stato 3
SELECT * FROM FOPT_GEDOCCRE 
WHERE COD_NDG_CEDE = 1000807
COD_sTAT_DOCU -> PORTARE IN STATO 001

--2024/34 soggetto da eliminare quindi da fare update con stato 010(estinto)
update gagt_ndgutent
set cod_stato ='010'
where cod_soggetto='1000852'

INSERT INTO GAGT_SPORBANC 
("COD_SPOR","DES_SPOR","COD_SOGGETTO","COD_ABI","COD_CAB","COD_TELEFONO","DES_SIGLA","COD_CAB_COMU","COD_PROV_SPOR","DES_COMU_SPOR","DES_INDI_SPOR","COD_CAP_SPOR","COD_NAZI","DAT_FINE_VALI","COD_SWIFT","COD_ENTE_MODI","COD_ENTE_CENS","DAT_CENS","TIM_STAT","COD_ABI_PREC","COD_CAB_PREC","COD_CIN_ABI","COD_CIN_CAB","COD_ABI_AUI","COD_NAZI_AUI","FLG_BONI_URGE","DES_RID_SPOR") 
VALUES ('0869254040 ','BANCA DI CREDITO COOPERATIVO DI BRESCIA S.C. FILIALE DI BAGNOLO MELLA',null,8692,54040,null,null,540401,'BS','BAGNOLO MELLA','VIA GRAMSCI 129 - B','25021 ','086',null,null,'HD','HD',20231010,{ts '2024-02-05 11:11:01.832154'},null,null,'6','1',null,null,'N',null);
20231207000681588                


--2024/39 - BANCA DEL FUCINO
SELECT * FROM FOPT_GEDOCCRE
WHERE COD_SOCRIFERIMENTO = '24'
AND COD_NDG_CEDE = 1000679
AND COD_NDG_DEBI = 1000681

--bisogna andare su questa tabella entrando con cedente e debitore che indicano 
--e mettere il COD_STAT_DOCU in stato 002
-- aspettare cliente 

--gestione parametro ffgt_lisipara
--se flg delibara è S bisogna modificare da pef
-- ffgt_valparls (valori) ticket 2024/40 fucino


--ticker 2024/65 e 2024/112 Mappatura NDG K4F con NDG Cedacri 
SELECT a.cod_sogg_codi, a.cod_estr, b.des_sogg_uten  FROM gagt_codieste a , gagt_ndg b
where a.cod_sogg_codi = b.cod_soggetto
and cod_tipo_codi=100





SELECT * FROM FDBT_DBINUMSC  --tabella per trovaro descrizone tasso ER08

WHERE NUM_PR_LIN_CREDITO = 1700


--2024/80 RESET PASSWORD ILLIMITY
-- FILTRARE PER QUESTE TABELLE PER VEDERE SE è ANDATO IN FALIED
SELECT * FROM EVEN_EVTQUEUE
where tms_cens like '%2024-03-26%'
--and cod_type
and id_event ='894508'
order by tms_cens desc

SELECT * FROM EVEN_EVTPARAM
where id_event ='894508'




SELECT * FROM FOPT_PARTITA
WHERE NUM_PR_LIN_CREDITO = 10384
AND DAT_CHIU_DEBI_FCTG IS NULL
AND COD_SOCRIFERIMENTO = '16'
 
SELECT * FROM FFGT_CONTO --SALD DISP -8783,89
WHERE NUM_PR_LIN_CREDITO = 10384
AND COD_SOCRIFERIMENTO = '16'
 
SELECT SUM(IMP_MOVI_FINZ) FROM FOPT_MOVICONT --8783,89
WHERE NUM_PR_LIN_CREDITO = 10384
AND DAT_DISP_CEDE IS NOT NULL
AND COD_SOCRIFERIMENTO = '16'
 
SELECT SUM(IMP_MOVI_FINZ) FROM FOPT_MONTECRE
WHERE NUM_PR_LIN_CREDITO = 10384 -- -1085,75
AND COD_SOCRIFERIMENTO  = '16'
 
SELECT COD_CAUS, SUM(IMP_MCRE) FROM FOPT_MONTECRE
WHERE NUM_PR_LIN_CREDITO = 10384
GROUP BY COD_CAUS


--per sqlcode error 803 fare questi prog  Errore lavorazione pef 
SELECT * FROM FFGT_PROFDCP
WHERE COD_RAND_COPP=37903988
SELECT * FROM FFGT_PROFCPA
WHERE COD_RAND_COPP=37903988

update FFGT_PROFCPA
set cod_socriferimento ='XX'
WHERE COD_RAND_COPP=566301461
update FFGT_PROFDCP
set cod_socriferimento ='XX'
WHERE COD_RAND_COPP=566301461

--scarti
INSERT INTO GDET_RELCOGE (COD_SOCRIFERIMENTO,COD_CAUS_MOVI,COD_CAUS_COGE,COD_MERC,FLG_SOFF_CEDE,FLG_SOFF_DEBI,FLG_SOLO_CESS,COD_TIPO_UTIL_RAPP,FLG_CLAS_CRED,COD_MEZZ_INCA,COD_TIPO_SEGM_GEST,COD_TIPO_EMES,COD_PUTO_FRM,FLG_PAESE_UE,FLG_DECR_INGI,FLG_RICE,FLG_CART,FLG_FATT_PUTO,COD_GEST_MAND_CONF) 
VALUES ('24','0674','EI0308    ','   ','N',' ','N','  ','I','   ','   ','   ','E',' ',' ','N',' ',' ',' ');

--tabelle PEF
SELECT * FROM GDET_PEF3FACO
--where cod_userid ='203153'


SELECT * FROM GDET_PEF3STUT
--where cod_uten ='203153'

 SELECT * FROM FTPT_ERRGC30 --errori cessione 
WHERE COD_FLUS  = 'WCW0000002848240506'


delete from tcon_filekey    where num_id in ('209654');
delete from tcon_relidx     where num_id in ('209654');
delete from tcon_bdcidx     where num_id in ('209654');
delete from tcon_hdcidx     where num_id in ('209654');
delete from tcon_bdcmpx     where num_id in ('209654');
delete from tcon_dlvqupar   where num_dlv in (select num_dlv from tcon_dlvqueue where num_id in ('209654'));
delete from tcon_dlvqueue   where num_id in ('209654');
delete from tcon_dlvpostel  where num_id in ('209654');
update scpr_logproc set flg_stat='0'  where num_id in ('209654');
 
select * from scpr_logproc  where num_id in ('209654');

--rigenerazione scritp
--serve per rigenrare script andato in errore e serve a rilanciarelo script in stato 0
-----


--cambio debitore tk 2024/139
--per modificare il debitore di una fattura, occorre procedere dalla transazione KR07, valorizzando opportunamente i filtri e inserendo come tipo operazione "Debitore e Indirizzo", successivamente nel Dettaglio all'interno dei DAti di Coppia sarà possibile inserire il nuovo debitore."


 
SELECT * FROM EVEN_EVTPARAM -- movimenti wof
WHERE ID_EVENT IN( 23729,23794,23793,23792,23791,23790,23789,23788,23787,23786,23785,23784,23783,23782,23781,23780,23779,23778,
23777,23776,23775,23774,23773,23772,23771,23770,23769,23768,23767,23766,23765,23764,23763,23762,23761,
23760,23759,23758,23757,23756,23755,23754,23753,23752,23751,23750,23749,23748,23747,23746,23745,23744,
23743,23742,23741,23740,23739,23738,23737,23736,23735,23734,23733,23732,23731,23730,23729)
AND COD_PARAM_NAME = 'TESTO' 

--LIR WOF
UPDATE FOPT_GEDOCCRE
SET COD_STAT_DOCU ='001'
where  COD_NDG_cede = 1000988
and COD_STAT_DOCU = '002'

-- firme  2024/206 FUCINO -  Firma digitale ARUBA PEC - onboarding
--scrivere a Marco.Colatruglio@finwave.it di disattivare , chiudere tk e appena il cliente da riscontro di attivarle scrivere a colatruglio di attivare.


--2024/279 Anomalia lettere di Notifica nota di credito
SELECT A.NUM_PR_LIN_CREDITO,A.COD_SOGGETTO,B.ANA_SOGGETTORID,A.COD_STATO_LIN_PLAF, C.COD_PARAM_LIN_SIST, C.COD_VALO_PARA
FROM FFGT_LINEACRE A, GAGT_NDGUTENT B , FFGT_LICREPAR C
WHERE A.COD_SOGGETTO = B.COD_SOGGETTO
AND A.NUM_PR_LIN_CREDITO = C.NUM_PR_LIN_CREDITO
AND C.COD_PARAM_LIN_SIST ='155'
AND C.COD_VALO_PARA ='S'
AND A.COD_STATO_LIN_PLAF NOT IN ('004','010','001')
