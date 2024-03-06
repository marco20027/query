SET CURRENT SQLID = 'BUFP01'
 
--ticket Richiesta scollegamento server

SELECT * FROM GDET_CTBSERWS  --scollegare
WHERE COD_SERVIZIO IN ('CEDACFIDI                ','CEDACREP                 ')
--- PER SCOLLEGARE
UPDATE GDET_CTBSERWS
SET FLG_ATTIVO = 'N'
--SELECT * FROM GDET_CTBSERWS
WHERE FLG_ATTIVO = 'S'
AND COD_SERVIZIO IN ('CEDACFIDI                ','CEDACREP                 ')
/*Ciao, server scollegato.
Attendiamo riscontro per ricollegare.
Marco
QUANDO ARRIVA MAIL CHIUDERE IL TICKET CON LA SEGUENTE NOTA:
Ciao, server collegato.
Marco*/
-- PER COLLEGARE
UPDATE GDET_CTBSERWS
SET FLG_ATTIVO = 'S'
--SELECT * FROM GDET_CTBSERWS
WHERE FLG_ATTIVO = 'N'
AND COD_SERVIZIO IN ('CEDACFIDI                ','CEDACREP                 ')