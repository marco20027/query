SET CURRENT SQLID = 'DSFP01' -- settare l'ambiente desio

--START G
SELECT COD_PROC, DAT_ELAB, TIM_END  FROM SCPR_ELABTIME
WHERE COD_PROC LIKE '%DSGPSP01%'
ORDER BY DAT_ELAB DESC, TIM_START DESC

--FINE G
SELECT COD_PROC, DAT_ELAB, TIM_END  FROM SCPR_ELABTIME
WHERE COD_PROC  LIKE '%DSGPSP02%'
ORDER BY DAT_ELAB DESC, TIM_START DESC

--VERIFICARE CHE SIANO ARRIVATE LE MAIL DEI 5 FLUSSI DA CEDACRI (INTORNO ALLE 8) !!ATTENZIONE A VOLTE VANNO NELLA POSTA INDESIDERATA. (AG8D LASCIARLO SOSPESO)

--FLUSSI VS CEDACRI (IF94 A VOLTE VUOTO)
SELECT P.NUM_ID, P.COD_PROC, P.FLG_STAT, P.DES_FILE, D.TMS_CENS, D.TMS_SEND, D.DLV_STATUS
FROM SCPR_LOGPROC P, TCON_DLVQUEUE D
WHERE P.COD_PROC IN ('DSGPIF4R','DSGPIF19','DSGPIF93','DSGPIF94','DSGPAG82')
AND P.NUM_ID = D.NUM_ID
ORDER BY P.TMS_CENS DESC 

--Flusso giornaliero OBJFIN verso CEDACRI --IF54
SELECT P.NUM_ID, P.COD_PROC, P.FLG_STAT, P.DES_FILE, D.TMS_CENS, D.TMS_SEND, D.DLV_STATUS, P.COD_OUTP FROM SCPR_LOGPROC P, TCON_DLVQUEUE D
WHERE P.COD_PROC IN ('OBJFING')
AND P.NUM_ID = D.NUM_ID
ORDER BY P.TMS_CENS DESC

--CONTROLLARE CHE SIANO OK
SELECT * FROM SCPR_ELABTIME
WHERE COD_PROC IN ('DSGPIF54','DSGPIF64','DSMPIF54','DSMPIF64','DSMPIF55','DSMPIF65')
ORDER BY DAT_ELAB DESC

--SCARTI
SELECT * FROM FCGT_MOVIECBC
WHERE COD_STAT_MOVI = 'S'

SELECT * FROM TCON_DLVQUEUE
ORDER BY TMS_CENS DESC

--VERIFICA GENERICA ERRORI
SELECT * FROM SCPR_ELABTIME
WHERE DES_ESITO LIKE '%ERROR%'
ORDER BY DAT_ELAB DESC, TIM_START DESC

--VERIFICA OUTPUT IN ERRORE
select * from scpr_logproc 
where (flg_stat in ('3') or (flg_stat ='1' and cod_outp<>'WEB'))   
and date(tms_cens) > '2023-06-01'
order by num_id desc
19747
--tipo di join
SELECT A.COD_SOGG_CODI, B.DES_SOGG_UTEN, A.COD_ESTR FROM GAGT_CODIESTE A, GAGT_NDG B
WHERE A.COD_SOGG_CODI = B.COD_SOGGETTO 
AND A.COD_TIPO_CODI = '003'


--- stampe post office   
--con seguente ticket BUONGIORNO CI SONO DIVERSI FLUSSI DI ESTRATTO CONTO CEDENTE DEL 4/1 ANDATI IN ERRORE CI SONO DIVERSI FLUSSI ESTRATTO CONTO DEBITORE DEL 3/1 ANDATI IN ERRORE VI PREGHIAMO DI VOLERLI REINVIARE IN AUTOMATICO SALUTI 

SELECT * FROM WRDC_HEADER -- COD_STATO VA MESSO IN STATO I
WHERE ID_FLUSSO = '10c6b2bc-2a74-4fbb-a6b8-713bc531a5ec'


UPDATE WRDC_DETAIL
SET COD_STATO = '0', COD_STATO_DLVRY = '0'
WHERE ID_FLUSSO = '10c6b2bc-2a74-4fbb-a6b8-713bc531a5ec'
AND COD_STATO = '3'

SELECT * FROM WRDC_HEADER -- COD_STATO VA MESSO IN STATO I
WHERE ID_FLUSSO = '3e2f717d-f229-47b6-a0ca-64715a06f118'

UPDATE WRDC_DETAIL
SET COD_STATO = '0', COD_STATO_DLVRY = '0'
WHERE ID_FLUSSO = '069a2a35-3ba5-4337-a095-4f1a0374d997'
AND COD_STATO <> '2'

UPDATE WRDC_DETAIL
SET COD_STATO = '0', COD_STATO_DLVRY = '0'
WHERE ID_FLUSSO IN('2989bc53-115b-4062-b15d-c247e91da787','')
AND COD_STATO = '3'

UPDATE WRDC_HEADER -- COD_STATO VA MESSO IN STATO I
SET COD_STATO ='I'
WHERE ID_FLUSSO = 'b83ddc76-4aa3-40da-bfb8-9f4d3deb31bf'


--FFGT_IDOCUMEN per funzione FI05


--travasi simulazioni  
--travaso simulazione mese corrente 2024
--cliente
--priority high 
--descrizone 
--gruppo it
--in cc fabio client hd, mensili sviluppo
--data --> fine del mese

SELECT * FROM gdet_ctblsist --TABELLA DELLE LINEE DI SISTEMA

--data revoca 2022-10-07  data emissione 2024-01-02 (tabella fopt_partita)
-- ambiente prod multisoc SET Current sqlid ='FPFP01'


--2024/35 IFIR utilizzare query sottostante 
UPDATE FTPT_PARTITCB
SET FLG_SPLIT_PAYM = 'N'
WHERE COD_FLUS='WCW0000017263240308' 
--AND COD_RAND_RAGG ='6537' --consolidare la cessione(QUERY PER RISOLVERE IL TICKET 2024/13, FTPT_PARTITCB,FTPT_RAGGRUCB) va anche azzerato importo iva
SELECT * FROM FTPT_RAGGRUCB
WHERE COD_FLUS ='WCW0000016870240212' --> trova linea di credito collegata a il cod_flus


FOPT_RIGAPART
2024/17 -- semplice update sullo stato mettere in 2 quando è 3

2024/18 --sulla cede boni mette a XX il codice società 

--per controllare mensile e giornaliera --> andare in grimaldel e controllare job in esecuzione


-- ticket guber 
--2024/14 guber
update WRDC_HEADER -- tabella per post office 
set cod_stato ='i'


select a.num_pr_lin_Credito, a.cod_ndg_debi, b.des_sogg_uten, a.cod_tipo_fido, a.cod_ndg_Cede, c.des_sogg_uten, cod_stat_oper, des_erro, a.cod_userid, a.tms_cens, a.tms_varz
from ftpt_cewsfidi a, gagt_ndg b, gagt_ndg c
where a.cod_socriferimento = '21'
and   b.cod_soggetto = a.cod_ndg_Debi
and   c.cod_soggetto = a.cod_ndg_Cede
and  cod_stat_oper not in ('RAINV', 'COINV', 'RAPFB')
union
select a.num_pr_lin_Credito, 0, ' ', a.cod_tipo_fido, a.cod_ndg_Cede, c.des_sogg_uten, cod_stat_oper, des_erro, a.cod_userid, a.tms_cens, a.tms_varz
from ftpt_cewsfidi a, gagt_ndg c
where a.cod_socriferimento = '27'
and   c.cod_soggetto = a.cod_ndg_Cede
and   a.cod_ndg_Debi = 0
and  cod_stat_oper not in ('RAINV', 'COINV')
order by 1, 11
 
2. query per estrarre occorrenze in errore
 
 
select * from ftpt_cewsfidi
where cod_socriferimento = '27'
and  ( cod_stat_oper not in ( 'RAINV', 'RAPFB', 'COINV')
       or (cod_stat_oper in( 'RAINV', 'COINV') and date(tms_cens) > current date - 4 days))


--2024/30 cessione da eliminare sullo stato da mettere in 001
SELECT * FROM FTPT_RAGGRUCB --METTERE IN STATO 001
WHERE COD_FLUS LIKE '%16867%'


--2024/36
--fopt_fatexml e fopt_partita controllare fatture se no mettere 000 su cod_invi

--se K4F servizio non attivo
SELECT * FROM k4f_servizio --> mettere flag a S


-- linea revocata
--vedere se gli output sono a 0 e la linea non aperta
SELECT * FROM FOPT_PARTITA
WHERE NUM_PR_LIN_CREDITO = 3194
AND DAT_CHIU_DEBI_FCTG IS NULL
AND COD_SOCRIFERIMENTO = '27'
 
SELECT * FROM FFGT_CONTO --imp sald da vedere se è 0
WHERE NUM_PR_LIN_CREDITO = 3194
AND COD_SOCRIFERIMENTO = '27'
 
SELECT SUM(IMP_MOVI_FINZ) FROM FOPT_MOVICONT --8783,89
WHERE NUM_PR_LIN_CREDITO = 3194
AND DAT_DISP_CEDE IS NOT NULL
AND COD_SOCRIFERIMENTO = '27'
 
SELECT SUM(IMP_MOVI_FINZ) FROM FOPT_MONTECRE
WHERE NUM_PR_LIN_CREDITO = 3194 -- -1085,75
AND COD_SOCRIFERIMENTO  = '27'
 
SELECT COD_CAUS, SUM(IMP_MCRE) FROM FOPT_MONTECRE
WHERE NUM_PR_LIN_CREDITO = 3194
GROUP BY COD_CAUS

SELECT A.COD_RAND_PRTT                                              
       FROM FOPT_PARTITA  A                                    
           ,GDET_CTLTIPAR B                                    
      WHERE A.COD_SOCRIFERIMENTO = '27'
        AND A.NUM_PR_LIN_CREDITO = 3194
        AND A.COD_RAND_COPP_GEST = 57802056    
        AND (A.DAT_CHIU_DEBI_FCTG IS NULL                      
         OR  A.DAT_CHIU_EMIT      IS NULL)                      
         AND B.COD_TIPO_PRTT      = A.COD_TIPO_PRTT            
         AND B.COD_LING_USER      ='086'   
         AND B.COD_NATU_PRTT      = 'C'        

select cod_flus from fopt_partita a, gdet_ctblsist where a.cod_socriferimento ='27' and a.num_pr_lin_Credito = 3194 
and (A.DAT_CHIU_DEBI_FCTG IS NULL OR A.DAT_CHIU_EMIT IS NULL) 
AND B.COD_TIPO_PRTT = A.COD_TIPO_PRTT AND B.COD_LING_USER ='086' AND B.COD_NATU_PRTT ='C'

SELECT * FROM FOPT_SALDCOPP
where num_pr_lin_credito=3194