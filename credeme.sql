SET CURRENT SQLID = 'CRFP01'
 
--ticket 2024/149

SELECT * FROM FFGT_LICREPAR
WHERE NUM_PR_LIN_CREDITO = 79747 --(linea di credito)
and cod_param_lin_sist in ( '280','180' )


-- IN  sintesi si vanno a mettere a N questi parametri 
-- si sospende ticket e quando hanno finito li rimettiamo a s
-- caso salvato nei doc 'CRD Sblocco conto NAQ'
--- Si sospende  E POI SI CHIUDE 


--ticket 2024/148


SELECT * FROM FFGT_IDOCUMEN
--SET   COD_SOCRIFERIMENTO = 'FM'
WHERE COD_SOGGETTO = 109042
AND   COD_DOCUMENTO = 'SDD'
AND   NUM_PR_DOCUMENTAZ = 157384



UPDATE  FFGT_IDOCUMEN
SET COD_SOCRIFERIMENTO = 'HD'
WHERE COD_SOGGETTO = 109042
AND   COD_DOCUMENTO = 'SDD'
AND   NUM_PR_DOCUMENTAZ = 157384