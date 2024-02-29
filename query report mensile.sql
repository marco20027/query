--Recuperare la data cambio da inserire al posto di :DATCAMB:
SELECT MAX(DAT_CAMB) 
FROM  FOPT_CAMBIO
--la data fine mese e inizio mese sono da inserire al posto di :DATFM e :INIZMESE 
SELECT * FROM FDBT_DBINUMCE --PER LA STAFFA
--Foglio 1 - Tempi di esecuzione (delta tra inizio, XXXXSP01, e fine, XXXXSP02, tenendo però conto di eventuali interruzioni dovute a errori, nel calcolo perciò non vanno considerati i tempi di inattività)
SELECT * FROM  SCPR_ELABTIME
WHERE COD_PROC LIKE '%XXMCXX%'
ORDER BY DAT_ELAB DESC,TIM_START DESC  
321808.170
--Foglio 2 - Ricavi
--Cedente: Interessi capitalizzati(LS) - Rateo interessi(RS) - Mora(LM) - Rateo mora(RM)
  SELECT FLG_TIPO_ELAB AS TIPO,                              
        FLG_TIPO_RAPP AS NOR_MORA,                          
        SUM ( CAST (                                        
           I.IMP_NUM /                                      
           CAST (COALESCE(C.IMP_VALO_CAMB,1 ) AS FLOAT )    
        AS DECIMAL (18,3) ) )  AS NUMERI,                   
        SUM ( CAST (                                        
           I.IMP_INTR /                                     
           CAST (COALESCE(C.IMP_VALO_CAMB,1 ) AS FLOAT )    
        AS DECIMAL (18,3) ) )  AS INTE                      
 FROM    FDBT_DBINUMCE I                              
        LEFT  OUTER JOIN  FOPT_CAMBIO C ON            
              I.COD_DIVS           = C.COD_DIVS             
         AND  C.DAT_CAMB           = :DATCAMB               
 WHERE  I.COD_SOCRIFERIMENTO = '15'                          
   AND  I.DAT_RIFE           = :DATFM                    
   AND  I.FLG_TIPO_RAPP      IN ('S','M') 
   AND  I.COD_TIPO_NUM       <> 'TEX'  
 GROUP  BY I.FLG_TIPO_ELAB ,           
           I.FLG_TIPO_RAPP          
 ORDER  BY 1,2 DESC        
 WITH UT,            
 WITH UR;    
   

--Commissioni: di cui plus factoring - di cui pendo - di cui puto + Altri ricavi
SELECT A.COD_TIPO_PRTT, A.DESCR, SUM(A.IMP_COGE)
FROM (
SELECT P.COD_TIPO_PRTT, X.COD_PCES, R.IMP_COGE
     , CASE WHEN VALUE(X.COD_PCES,' ') IN( ' ' ,'DW16')
            THEN 'Altri ricavi fatturati/da fatturare'
            WHEN X.COD_PCES = 'DW14'
            THEN 'Commissioni gestione prosoluto     '
            WHEN X.COD_PCES = 'DW13'
             AND X.COD_CAUS     IN ('C121' ,'C122' , 'C123', '121C', '122C' , '123C','C165','165C')
            THEN 'Commissioni plusfactoring          '
            WHEN X.COD_PCES = 'DW13'
             AND X.COD_CAUS NOT IN ('C121' ,'C122' , 'C123', '121C', '122C' , '123C','C165','165C')
            THEN 'Commissioni prosolvendo            '
            ELSE ' '
       END AS DESCR
     , R.COD_CAUS
  FROM FOPT_RIGAPART R
       LEFT JOIN GDET_PCESCAUS X
         ON X.COD_SOCRIFERIMENTO = R.COD_SOCRIFERIMENTO
        AND X.COD_CAUS           = R.COD_CAUS
        AND X.COD_PCES IN ('DW13','DW14','DW16')
     , FOPT_PARTITA  P
     , GDET_CTBCAUPA A
 WHERE R.COD_SOCRIFERIMENTO = '15' 
   AND P.COD_SOCRIFERIMENTO = R.COD_SOCRIFERIMENTO
   AND P.COD_SOCRIFERIMENTO = X.COD_SOCRIFERIMENTO
   AND P.NUM_PR_LIN_CREDITO = R.NUM_PR_LIN_CREDITO
   AND P.COD_RAND_PRTT      = R.COD_RAND_PRTT
   AND P.DAT_REGI           =  :DATFM    
   AND NOT R.COD_CAUS LIKE '%D%'
   AND NOT A.DES_CAUS_ESTE LIKE '%INTER%'
   AND A.COD_SOCRIFERIMENTO = R.COD_SOCRIFERIMENTO
   AND A.COD_CAUS = R.COD_CAUS ) A
GROUP BY  A.COD_TIPO_PRTT, A.DESCR 
   WITH UR;
 R.COD_SOCRIFERIMENTO ='24(FUCINO), 27(DESIO)'
                       

-- Staffa cedente: numero cc senza tasso - sotto soglia - in blocco staffa 

SELECT
 SUM( CASE WHEN A.DT_BLOC IS NOT NULL
           THEN 1
           ELSE 0
      END) AS CC_BLOCCO
,SUM( CASE WHEN A.TIPO_ELAB = 'R'
           and   A.TOT_INTR < A.SOGLIA
            THEN 1
            ELSE 0
       END) AS CC_SOTTOSOGLIA
,SUM( CASE WHEN A.TIPO_ELAB = 'N'
            AND (    A.IMP_SALD_CONT   <> 0
                  OR A.IMP_SALD_CONT_2 <> 0
                  OR A.NRO_MOVIM       <> 0)
            AND (    A.TASSO = 'XXXX'
                 OR (    A.TASSO <> 'XXXX'
                     AND A.BASE  = 'XXXX'
                     AND A.TB IS NOT NULL))
            THEN 1
            ELSE 0
       END) AS CC_SENZA_TASSO
 FROM (
SELECT DISTINCT
       C.NUM_PR_LIN_OPERA AS LO
     , A.DAT_BLOC_STAF AS DT_BLOC
     , VALUE(N.FLG_TIPO_ELAB,'N')  AS TIPO_ELAB
     , C.COD_PERI_CAPZ  AS TIPO_CAPZ , MONTH( :DATFM   )
     , S.IMP_STAN       AS SOGLIA
     , SUM(VALUE(N.IMP_INTR,0))  AS TOT_INTR
     , VALUE(K.TASSO,'XXXX')  AS TASSO
     , VALUE(K.BASE ,'XXXX')  AS BASE
     , SUM(C.IMP_SALD_CONT) AS IMP_SALD_CONT
     , SUM(VALUE(C2.IMP_SALD_CONT,0)) AS IMP_SALD_CONT_2
     ,COUNT(X.COD_SOCRIFERIMENTO) AS NRO_MOVIM
     , K.TB
FROM
 FDBT_DBIFIDI  D
 LEFT JOIN FOPT_AZIOLEGA A
   ON A.COD_SOCRIFERIMENTO = D.COD_SOCRIFERIMENTO
  AND A.COD_SOGGETTO       = D.COD_SOGGETTO
  AND A.PRG_PRATICA = (SELECT MAX(B.PRG_PRATICA)
                         FROM FOPT_AZIOLEGA B
                        WHERE B.COD_SOCRIFERIMENTO = A.COD_SOCRIFERIMENTO
                          AND B.COD_SOGGETTO       = A.COD_SOGGETTO)
,FDBT_DBICONTO C
 LEFT JOIN FDBT_DBINUMCE N
   ON N.COD_SOCRIFERIMENTO = C.COD_SOCRIFERIMENTO
  AND N.NUM_PR_LIN_OPERA   = C.NUM_PR_LIN_OPERA
  AND N.DAT_RIFE           = C.DAT_RIFE
  AND N.FLG_TIPO_RAPP    IN ('S','M')
 LEFT JOIN FDBT_DBICONTO C2
   ON C2.COD_SOCRIFERIMENTO = C.COD_SOCRIFERIMENTO
  AND C2.NUM_PR_LIN_OPERA   = C.NUM_PR_LIN_OPERA
  AND C2.DAT_RIFE           = LAST_DAY(C.DAT_RIFE - CAST(C2.COD_PERI_CAPZ AS INTEGER) MONTH)
 LEFT JOIN FOPT_MOVICONT X
   ON X.COD_SOCRIFERIMENTO = C.COD_SOCRIFERIMENTO
  AND X.NUM_PR_LIN_OPERA   = C.NUM_PR_LIN_OPERA
  AND X.DAT_CONT IS NOT NULL
  AND X.DAT_CONT BETWEEN  LAST_DAY(C.DAT_RIFE - CAST(C2.COD_PERI_CAPZ AS INTEGER) MONTH)  AND C.DAT_RIFE
 LEFT JOIN
 (SELECT R.NUM_PR_LIN_OPERA
       , R.COD_COND AS TASSO
       , R.COD_COND_NFCD AS TB
       , V.COD_COND AS BASE
 FROM
 FKNT_RELCOCNT R
 LEFT JOIN FKNT_VALOBASI V
   ON V.COD_SOCRIFERIMENTO = R.COD_SOCRIFERIMENTO
  AND V.COD_COND           = R.COD_COND_NFCD
  AND V.COD_DIVS           = R.COD_DIVS
  AND '2016-11-30' BETWEEN V.DAT_INIZ_VALI AND VALUE(V.DAT_FINE_VALI,DATE('9999-12-31'))
 WHERE R.COD_SOCRIFERIMENTO = :COD_SOCRIFERIMENTO
   AND R.COD_COND           = 'C301'
   AND '2016-11-30' BETWEEN R.DAT_INIZ_VALI AND VALUE(R.DAT_FINE_VALI,DATE('9999-12-31'))) K
ON K.NUM_PR_LIN_OPERA = C.NUM_PR_LIN_OPERA
,GDET_CTBSTDSO S
WHERE D.COD_SOCRIFERIMENTO = '15'
  AND D.DAT_RIFE           = :DATFM
  AND VALUE(D.COD_STATO_LIN_PLAF,'000') NOT IN ('010','004','000','001')
  AND C.COD_SOCRIFERIMENTO = D.COD_SOCRIFERIMENTO
  AND C.NUM_PR_LIN_CRE_CED = D.NUM_PR_LIN_CREDITO
  AND C.DAT_RIFE           = D.DAT_RIFE
  AND C.COD_PERI_CAPZ     <> '021'
  AND C.COD_PERI_CAPZ     <> '021'
  AND C.DAT_CHIU_CONT     IS NULL
  AND C.NUM_PR_LIN_OPERA  <> 0
  AND S.COD_SOCRIFERIMENTO = C.COD_SOCRIFERIMENTO
  AND S.COD_TIPO_STAN      = '704'
GROUP BY C.NUM_PR_LIN_OPERA
       , A.DAT_BLOC_STAF
       , N.FLG_TIPO_ELAB
       , C.COD_PERI_CAPZ
       , S.IMP_STAN
       , K.TASSO
       , K.BASE
       , K.TB) A
WITH UR;  


--SELECT * FROM 
            
--Debitore: Interessi di dilazione(LD) - Rateo interessi(RD) - Interessi ritardato pagamento(LR) - Rateo ritardato pagamento(RR)
  SELECT I.COD_COND_TASS,A.DES_CAUS_ESTE, I.COD_TIPO_ELAB AS TIPO,                         
        I.COD_TIPO_RAPP AS DILARIT,                      
        SUM ( CAST (                                     
           I.IMP_NUM  /                                  
           CAST (COALESCE(C.IMP_VALO_CAMB,1 ) AS FLOAT ) 
        AS DECIMAL (18,3) ) )  AS NUME,                  
        SUM ( CAST (                                     
           I.IMP_INTR /                                  
           CAST (COALESCE(C.IMP_VALO_CAMB,1 ) AS FLOAT ) 
        AS DECIMAL (18,3) ) )  AS INTE                   
 FROM    FDBT_DBINUDEB I                           
        LEFT  OUTER JOIN  FOPT_CAMBIO C ON         
              I.COD_DIVS           = C.COD_DIVS          
         AND  C.DAT_CAMB           =  :DATCAMB    
        LEFT JOIN GDET_CTBCAUPA A
          ON A.COD_SOCRIFERIMENTO = I.COD_SOCRIFERIMENTO
         AND A.COD_CAUS           = I.COD_COND_TASS     
 WHERE  I.COD_SOCRIFERIMENTO = '15'                       
   AND  I.DAT_RIFE           =   :DATFM                   
   AND  I.COD_TIPO_RAPP      IN ('R','D')
   AND  I.COD_TIPO_ELAB      IN ('L','R')      
 GROUP  BY I.COD_TIPO_ELAB ,                     
           I.COD_TIPO_RAPP ,
           I.COD_COND_TASS ,
           A.DES_CAUS_ESTE                       
 ORDER  BY 1,2                                 
 WITH UR;


--Debitore : Commissioni - Altri ricavi
SELECT A.COD_TIPO_PRTT, A.DESCR, SUM(A.IMP_COGE)
FROM (
SELECT P.COD_TIPO_PRTT, X.COD_PCES, R.IMP_COGE
     , CASE WHEN VALUE(X.COD_PCES,' ') IN( ' ' ,'DW18')
            THEN 'Altri ricavi fatturati/da fatturare'
            WHEN X.COD_PCES = 'DW17'
            THEN 'Commissioni su maturato     '
            ELSE ' '
       END AS DESCR
     , R.COD_CAUS
  FROM FOPT_RIGAPART R
       LEFT JOIN GDET_PCESCAUS X
         ON X.COD_SOCRIFERIMENTO = R.COD_SOCRIFERIMENTO
        AND X.COD_CAUS           = R.COD_CAUS
        AND X.COD_PCES IN ('DW17','DW18')
     , FOPT_PARTITA  P
     , GDET_CTBCAUPA A
 WHERE R.COD_SOCRIFERIMENTO = '15' 
   AND P.COD_SOCRIFERIMENTO = R.COD_SOCRIFERIMENTO
   AND P.NUM_PR_LIN_CREDITO = R.NUM_PR_LIN_CREDITO
   AND P.COD_RAND_PRTT      = R.COD_RAND_PRTT
   AND P.DAT_REGI           =   :DATFM   
   AND NOT R.COD_CAUS LIKE '%C%'
   AND NOT A.DES_CAUS_ESTE LIKE '%INTER%'
   AND A.COD_SOCRIFERIMENTO = R.COD_SOCRIFERIMENTO
   AND A.COD_CAUS = R.COD_CAUS ) A
GROUP BY  A.COD_TIPO_PRTT, A.DESCR
   WITH UR;

--Numero debitori senza tasso: vedere report in TSfoglio


--Foglio 3 - Documenti vs clientela

--Cedente/Debitore: Estratti conto prodotti
SELECT  COD_TRAL
        ,CASE WHEN COD_TRAL IN ('ST005M','STE027','STE028','STE029')
              THEN 'E/C DEBITORE'
              WHEN COD_TRAL = 'STE023'
              THEN 'E/C DEBITORE MATURITY'
              WHEN COD_TRAL = 'ST006M'
              THEN 'E/C DEBITORE AL CEDENTE'
              WHEN COD_TRAL IN ('STE008','STE020')
              THEN 'E/C CEDENTE'
          END
        ,COUNT(*)                      
 FROM   FOPT_XTRIAL                     
 WHERE  COD_SOCRIFERIMENTO = '15'               
   AND  DAT_EMIS_TRAL      =  :DATFM    
   AND  COD_TRAL IN
('ST005M','STE027','STE023','STE028','STE029',
 'ST006M','STE008','STE020')
 GROUP  BY COD_TRAL                            
 WITH UR;
 
 
--Cedente: Soggetti con oustanding e assenza E/C
SELECT COUNT(A.COD_SOGGETTO)
FROM (
SELECT L.COD_SOGGETTO,SUM(C.IMP_SALD_CONT)
FROM FFGT_LINEACRE L
   , FFGT_LICREPAR R
   , FFGT_CONTO C
WHERE L.COD_SOCRIFERIMENTO = '15' 
  AND L.COD_STATO_LIN_PLAF NOT IN ('010','004')
  AND R.COD_SOCRIFERIMENTO = L.COD_SOCRIFERIMENTO
  AND R.NUM_PR_LIN_CREDITO = L.NUM_PR_LIN_CREDITO
  AND R.COD_PARAM_LIN_SIST = '071'
  AND R.COD_VALO_PARA     NOT IN ('021','022')
  AND (        R.COD_VALO_PARA = '01'
       OR (    R.COD_VALO_PARA = '03'
           AND MONTH('2016-11-30') IN ('03','06','09' ,'12'))
       OR (    R.COD_VALO_PARA = '06'
           AND MONTH('2016-11-30') IN ('06','12'))           
       OR (    R.COD_VALO_PARA = '12'
           AND MONTH('2016-11-30') ='12'))          
  AND C.COD_SOCRIFERIMENTO = L.COD_SOCRIFERIMENTO
  AND C.NUM_PR_LIN_CREDITO = L.NUM_PR_LIN_CREDITO
  AND C.DAT_CHIU_CONT IS NULL
  AND NOT EXISTS
  (SELECT 1 FROM FOPT_XTRIAL B
   WHERE B.COD_SOCRIFERIMENTO = L.COD_SOCRIFERIMENTO
     AND B.DAT_EMIS_TRAL      =  :DATFM 
     AND B.COD_NDG_CEDE       = L.COD_SOGGETTO
     AND B.COD_TRAL IN ('STE020','STE008')) 
GROUP BY L.COD_SOGGETTO
HAVING SUM(C.IMP_SALD_CONT) <> 0     ) A
WITH UR;


--Cedente/Debitore : numero fatture (cedente) e staffe (sia cedente che debitore) prodotte

SELECT COUNT(*) AS NUMERO_FATTURE, A.TIPO_EMESSO
FROM (
SELECT DISTINCT
       P.COD_RAND_PRTT
      ,P.COD_TIPO_PRTT, R.COD_TIPL_FATT
      ,CASE WHEN VALUE(S.COD_RAND_PRTT,0) <> 0
             AND VALUE(S.COD_NDG_DEBI,0)  <> 0
            THEN 'STAFFA DEBITORE'
            WHEN VALUE(S.COD_RAND_PRTT,0) <> 0
             AND VALUE(S.NUM_PR_LIN_OPERA,0)  <> 0
            THEN 'STAFFA CEDENTE '
            ELSE 'COMMISSIONI    '
       END AS TIPO_EMESSO
FROM FOPT_PARTITA P
LEFT JOIN FTPT_STAFFE S
 ON S.COD_SOCRIFERIMENTO = P.COD_SOCRIFERIMENTO
AND S.NUM_PR_LIN_CREDITO = P.NUM_PR_LIN_CREDITO
AND S.COD_RAND_PRTT      = P.COD_RAND_PRTT
   , GDET_CTLTIPAR A
   , FOPT_RIGAPART R  
WHERE P.COD_SOCRIFERIMENTO = '15' 
  AND P.DAT_REGI           =  :DATFM 
  AND P.COD_TIPO_PRTT  NOT IN ('P70','P73')
  AND A.COD_TIPO_PRTT      = P.COD_TIPO_PRTT
  AND A.COD_LING_USER      = '086'
  AND A.COD_NATU_PRTT      = 'E'  
  AND R.COD_SOCRIFERIMENTO = P.COD_SOCRIFERIMENTO
  AND R.NUM_PR_LIN_CREDITO = P.NUM_PR_LIN_CREDITO
  AND R.COD_RAND_PRTT      = P.COD_RAND_PRTT
  AND R.COD_TIPL_FATT      <> 'GG'
  ) A
GROUP BY  A.TIPO_EMESSO
WITH UR;


--Debitore: Soggetti con oustanding e assenza E/C
SELECT COUNT(DISTINCT F.COD_NDG_DEBI)
FROM (
SELECT F.COD_NDG_DEBI
FROM FFGT_LICREPAR L
   , FFGT_FIDOCOPP F
WHERE L.COD_PARAM_LIN_SIST = '124'
  AND L.COD_SOCRIFERIMENTO = '15' 
  AND L.COD_VALO_PARA NOT IN ( '21', '37')
  AND F.COD_SOCRIFERIMENTO = L.COD_SOCRIFERIMENTO
  AND F.NUM_PR_LIN_CREDITO = L.NUM_PR_LIN_CREDITO
  AND (        L.COD_VALO_PARA IN ( '01','1')
       OR (    L.COD_VALO_PARA = '03'
           AND MONTH('2016-11-30') IN ('03','06','09' ,'12'))
       OR (    L.COD_VALO_PARA = '06'
           AND MONTH('2016-11-30') IN ('06','12'))           
       OR (    L.COD_VALO_PARA = '12'
           AND MONTH('2016-11-30') ='12'))  
UNION
SELECT F.COD_NDG_DEBI
FROM FFGT_FICPPARA L
   , FFGT_FIDOCOPP F
WHERE L.COD_PARAM_LIN_SIST = '124'
  AND L.COD_SOCRIFERIMENTO = '15' 
  AND L.COD_VALO_PARA NOT IN ( '21', '37') --(NN STAMPARA E SETTIMANALE)
  AND F.COD_SOCRIFERIMENTO = L.COD_SOCRIFERIMENTO
  AND F.NUM_PR_LIN_CREDITO = L.NUM_PR_LIN_CREDITO
  AND F.COD_RAND_COPP      = L.COD_RAND_COPP
  AND (        L.COD_VALO_PARA IN ( '01','1')
       OR (    L.COD_VALO_PARA = '03'
           AND MONTH('2016-11-30') IN ('03','06','09','12'))
       OR (    L.COD_VALO_PARA = '06'
           AND MONTH('2016-11-30') IN ('06','12'))           
       OR (    L.COD_VALO_PARA = '12'
           AND MONTH('2016-11-30') ='12'))     ) F
, FOPT_PARTITA P
, GDET_CTLTIPAR A
WHERE P.COD_SOCRIFERIMENTO = '15' 
  AND P.DAT_CHIU_DEBI_FCTG IS NULL
  AND P.IMP_SALD_CDEB <> 0
  AND P.COD_NDG_DEBI_FCTG  = F.COD_NDG_DEBI
  AND A.COD_TIPO_PRTT      = P.COD_TIPO_PRTT
  AND A.COD_LING_USER      = '086'
  AND A.COD_NATU_PRTT      = 'C'
  AND NOT EXISTS
  AND IN 
  (SELECT 1 FROM FOPT_XTRIAL B
   WHERE B.COD_SOCRIFERIMENTO = P.COD_SOCRIFERIMENTO
     AND B.DAT_EMIS_TRAL      =  :DATFM 
     AND B.COD_NDG_DEBI       = P.COD_NDG_DEBI_FCTG
     AND B.COD_TRAL IN ('STE023','STE027','ST005M','ST005S','STE028','STE029'))
  WITH UR;


--Debitore: numero fatture prodotte 
SELECT * FROM FOPT_RIGAPART 
WHERE COD_SOCRIFERIMENTO = '15' 
AND DAT_INIZ_CPTZ =  :DATFM 
AND COD_CAUS LIKE 'D%'
AND COD_TIPL_FATT = 'MM'  



--Foglio 4 - Esiti processi di archiviazione


--Affidamenti archiviati                             
 SELECT COUNT(*)                                  
 FROM  FFGT_LINEACRE                        
 WHERE COD_SOCRIFERIMENTO = '15'                  
 AND COD_STATO_LIN_PLAF = '010'                   
 AND DAT_CONT_VARZ BETWEEN :INIZMESE AND :DATFM            
 WITH UR;

--Plafond chiusi
SELECT COUNT(*)                                     
FROM  FFGT_FIDOCOPP                           
WHERE COD_SOCRIFERIMENTO = '15'                     
AND COD_STAT_LIN_PLAF = '010'                       
AND DAT_CONT_VARZ BETWEEN :INIZMESE AND :DATFM            
WITH UR;

--Conti archiviati
 SELECT COUNT(*)                               
 FROM  FFGT_CONTO                        
 WHERE COD_SOCRIFERIMENTO = '15'             
 AND DAT_CHIU_CONT BETWEEN :INIZMESE AND :DATFM     

--Fidi soggetto archiviati 


SELECT COUNT(*)
FROM  FFGT_lcrdebi
WHERE COD_SOCRIFERIMENTO = '15'
AND flg_tipo_linea = 'A'
AND COD_STATO_LIN_PLAF=  '010'
AND DATE(TIM_STAT) BETWEEN :INIZMESE AND :DATFM    


-- Report Direzionale
copiare da reporting direzionale report mensile

-- Cedenti operanti
copiare da reporting Comemrciali, analisi portafoglio, Cedenti operanti 