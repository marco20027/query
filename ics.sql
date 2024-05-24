set current sqlid ='CSFP01' 

SELECT * FROM SCPR_ELABTIME
WHERE DES_ESITO = 'ERROR'
ORDER BY DAT_ELAB DESC, TIM_START DESC --csgpfg96 sempre in error verificare se c'è qualcosa di nuovo
 
select * from scpr_logproc 
where (flg_stat in ('3') or (flg_stat ='1' and cod_outp<>'WEB'))   
and date(tms_cens) >= '2024-01-29'
order by num_id desc
 
SELECT * FROM FCGT_MOVIECBC
WHERE COD_STAT_MOVI = 'S'

select * from TCON_DLVQUEUE --tabella del tconverto vedo tutti i file inviati controllare record in stato tre 
order by tms_cens desc 


--2024/16
 
SELECT * FROM FTPT_CEWSFIDI
ORDER BY ID_WS_FIDI DESC
--comunicare a ics il motivo dell'errore poi loro verificano con cedacri quando ci dicono di reinviare mettiamo RAREI
 

 0249 (cod fiscale) -- > da togliere su cerverd aosta
0967

--2024/72 ticket girare a studio informatica
