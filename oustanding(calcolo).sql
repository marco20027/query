<?xml version="1.0" encoding="UTF-8"?>
<beans _quit="K4F_INQUIRY" dirJava="src" dirWeb="web">
<xml-querydefiner>
    <query name="Analisi Montecrediti Debitore" type="SQL" label="qryAnlsDebi" queryID="KM05_Debi">
        <sql dbType="DB2">
		<select>
		SELECT
	                 F.COD_NDG_DEBI      
	                 ,COALESCE(SD.DES_RAGI_SOCL, ' ') AS DES_RAGI_SOCL_DEBI      
      				,CASE
	                 	WHEN SD.COD_STAT_RISC = '   '
	                 		THEN 'BON'  
	                 	ELSE
	                 		SD.COD_STAT_RISC
	                 	END AS COD_STAT_RISC_DEBI
                     ,COALESCE(SD.COD_TIPO_RATG, ' ') AS COD_TIPO_RATG_DEBI
                     ,COALESCE(SD.COD_RATG, ' ') AS COD_RATG_DEBI
	                 ,SUM(F.IMP_SCAD_01)AS IMP_SCAD_01      
	                 ,SUM(F.IMP_SCAD_02)AS IMP_SCAD_02      
	                 ,SUM(F.IMP_SCAD_03)AS IMP_SCAD_03      
	                 ,SUM(F.IMP_SCAD_04)AS IMP_SCAD_04      
	                 ,SUM(F.IMP_SCAD_05)AS IMP_SCAD_05      
	                 ,SUM(F.IMP_SCAD_06)AS IMP_SCAD_06      
			,SUM(F.IMP_SCAD_01 + F.IMP_SCAD_02 + F.IMP_SCAD_03 + F.IMP_SCAD_04 + F.IMP_SCAD_05 + F.IMP_SCAD_06) AS IMP_SCAD_TOTA
	                 ,SUM(F.IMP_ASCA_01)  AS IMP_ASCA_01      
	                 ,SUM(F.IMP_ASCA_02)  AS IMP_ASCA_02      
	                 ,SUM(F.IMP_ASCA_03)  AS IMP_ASCA_03      
	                 ,SUM(F.IMP_ASCA_41)  AS IMP_ASCA_41      
	                 ,SUM(F.IMP_ASCA_42)  AS IMP_ASCA_42      
			,SUM(F.IMP_ASCA_01 + F.IMP_ASCA_02 + F.IMP_ASCA_03 + F.IMP_ASCA_41 + F.IMP_ASCA_42) AS IMP_TOTA_ASCA
			,SUM(F.IMP_SCAD_01 + F.IMP_SCAD_02 + F.IMP_SCAD_03 + F.IMP_SCAD_04 + F.IMP_SCAD_05 + F.IMP_SCAD_06 + F.IMP_ASCA_01 + F.IMP_ASCA_02 + F.IMP_ASCA_03 + F.IMP_ASCA_41 + F.IMP_ASCA_42) AS IMP_CDEB 
	                 ,SUM(F.IMP_SCAD_RICO_01) AS IMP_SCAD_RICO_01      
	                 ,SUM(F.IMP_SCAD_RICO_02) AS IMP_SCAD_RICO_02      
	                 ,SUM(F.IMP_SCAD_RICO_03) AS IMP_SCAD_RICO_03      
	                 ,SUM(F.IMP_SCAD_RICO_04) AS IMP_SCAD_RICO_04      
	                 ,SUM(F.IMP_SCAD_RICO_05) AS IMP_SCAD_RICO_05      
	                 ,SUM(F.IMP_SCAD_RICO_06) AS IMP_SCAD_RICO_06      
			,SUM(F.IMP_SCAD_RICO_01 + F.IMP_SCAD_RICO_02 + F.IMP_SCAD_RICO_03 + F.IMP_SCAD_RICO_04 + F.IMP_SCAD_RICO_05 + F.IMP_SCAD_RICO_06 ) AS IMP_TOTA_SCAD_RICO
	                 ,SUM(F.IMP_ASCA_RICO_01) AS IMP_ASCA_RICO_01      
	                 ,SUM(F.IMP_ASCA_RICO_02) AS IMP_ASCA_RICO_02      
	                 ,SUM(F.IMP_ASCA_RICO_03) AS IMP_ASCA_RICO_03      
	                 ,SUM(F.IMP_ASCA_RICO_41) AS IMP_ASCA_RICO_41      
	                 ,SUM(F.IMP_ASCA_RICO_42) AS IMP_ASCA_RICO_42      
			,SUM(F.IMP_ASCA_RICO_01 + F.IMP_ASCA_RICO_02 + F.IMP_ASCA_RICO_03 + F.IMP_ASCA_RICO_41 + F.IMP_ASCA_RICO_42) AS IMP_TOTA_ASCA_RICO
            ,COALESCE(T.IMP_TURN_PREC, 0) AS IMP_TURN_12MM 
            ,COALESCE(T.IMP_INCA_PREC, 0) AS IMP_INCA_12MM  
			,SCD.COD_NDC_LF AS COD_NDC_LF
			,SCD.COD_MDS AS COD_MDS
			,SCD.DES_MDS AS DES_MDS
			,SCD.COD_AREA_TER_SEG AS COD_AREA_TER_SEG
			,SCD.DES_AREA_TER_SEG AS DES_AREA_TER_SEG
			,SCD.COD_DIR_TERR_SEG AS COD_DIR_TERR_SEG
			,SCD.DES_DIR_TERR_SEG AS DES_DIR_TERR_SEG
			,SCD.COD_FILIALE_SEG AS COD_FILIALE_SEG
			,SCD.DES_FILIALE_SEG AS DES_FILIALE_SEG
			,SCD.COD_AREA_TER_ANAG AS COD_AREA_TER_ANAG
			,SCD.DES_AREA_TER_ANAG AS DES_AREA_TER_ANAG
			,SCD.COD_DIR_TER_ANAG AS COD_DIR_TER_ANAG
			,SCD.DES_DIR_TER_ANAG AS DES_DIR_TER_ANAG
			,SCD.COD_ANA_FIL_SEG AS COD_ANA_FIL_SEG
			,SCD.DES_ANA_FIL_SEG AS DES_ANA_FIL_SEG  
		/*</select>
		<where varID="FlgbScadS2">
			,SUM(F.IMP_TOCA_GG_CORR)      			   AS IMP_TURN_MESE      
			,SUM(F.IMP_INCA_NO_DILA + F.IMP_INCA_DILA) AS IMP_INCA_MESE
		</where>
		<where varID="FlgbScadDFS">
			,SUM(FF.IMP_TOCA_GG_CORR)      				 AS IMP_TURN_MESE      
			,SUM(FF.IMP_INCA_NO_DILA + FF.IMP_INCA_DILA) AS IMP_INCA_MESE
		</where>
		<where varID="FlgbScadS2">
	            FROM DWHT_CMFATTI F      
		</where>
		<where varID="FlgbScadDFS">*/
			FROM
				DWHT_CMSCADFS F
				JOIN DWHT_CMFATTI FF
				  ON  FF.COD_SOCRIFERIMENTO = F.COD_SOCRIFERIMENTO
				 AND FF.COD_NDG_CEDE = F.COD_NDG_CEDE
				 AND FF.NUM_PR_LIN_CREDITO = F.NUM_PR_LIN_CREDITO
				 AND FF.COD_NDG_DEBI = F.COD_NDG_DEBI
		/*</where>
		<staticWhere>*/
					 INNER JOIN DWHT_CMSOGG SC 
			       ON  SC.COD_SOCRIFERIMENTO = F.COD_SOCRIFERIMENTO
			       AND SC.COD_SOGGETTO       = F.COD_NDG_CEDE         
				   	LEFT OUTER JOIN GAGT_NDGGEST SCG
				   ON  SCG.COD_SOCRIFERIMENTO = SC.COD_SOCRIFERIMENTO
				   AND SCG.COD_NDG_GEST = SC.COD_NDG_GEST
				   AND SCG.COD_TIPO_RELA = 'SGE'
				   AND SCG.DAT_FINE IS NULL
				   	LEFT OUTER JOIN GDET_CTLSEGMG S
				   ON  S.COD_SOCRIFERIMENTO = SCG.COD_SOCRIFERIMENTO
				   AND S.COD_TIPO_SEGM_GEST = SCG.COD_TIPO_SEGM_GEST
				   AND S.COD_LING_USER = '086'
						INNER JOIN DWHT_CMSOGG SD 
			       ON  SD.COD_SOCRIFERIMENTO = F.COD_SOCRIFERIMENTO
			       AND SD.COD_SOGGETTO       = F.COD_NDG_DEBI     
						INNER JOIN DWHT_CMFDCEDE C
			       ON  C.COD_SOCRIFERIMENTO = F.COD_SOCRIFERIMENTO
			       AND C.NUM_PR_LIN_CREDITO = F.NUM_PR_LIN_CREDITO
			       AND C.COD_NDG_CEDE       = F.COD_NDG_CEDE
			       AND C.FLG_CLAS_CRED  'H' 
			      LEFT OUTER JOIN 
			          (SELECT A.COD_NDG_DEBI 
		                   ,SUM(A.IMP_TURN_PEND    + A.IMP_TURN_PUTO) AS IMP_TURN_PREC
		                   ,SUM(A.IMP_INCA_NO_DILA + A.IMP_INCA_DILA) AS IMP_INCA_PREC
		               FROM DWHT_PERIODO P
		                   ,DWHT_FATTI   A
		/*</staticWhere>		
		<where varID="CodSocriferimento">
					   WHERE A.COD_SOCRIFERIMENTO = $CodSocriferimento$
		</where>
		<where varID="Anno">
	    			   AND   P.NUM_ANNO = $Anno$
		</where>
		<where varID="Mese">
    				   AND   P.NUM_MESE = $Mese$
		</where>
		<staticWhere>*/
				   AND A.NUM_ANNO BETWEEN P.NUM_ANNO_PREC AND P.NUM_ANNO_MESE_PREC                       
				   AND ((A.NUM_ANNO = P.NUM_ANNO_MESE_PREC AND A.NUM_MESE = P.NUM_MESE_PREC ) OR (A.NUM_ANNO = P.NUM_ANNO_PREC AND A.NUM_MESE = P.NUM_MESE_ANNO_PREC))
			           GROUP BY  A.COD_NDG_DEBI
			           HAVING ( 
			                  SUM(A.IMP_TURN_PEND    + A.IMP_TURN_PUTO) 
			               OR SUM(A.IMP_INCA_NO_DILA + A.IMP_INCA_DILA) )) T
					ON  T.COD_NDG_DEBI = F.COD_NDG_DEBI
				LEFT OUTER JOIN GAGT_SEGMCOMM SCD ON SCD.COD_SOCRIFERIMENTO = F.COD_SOCRIFERIMENTO
												 AND SCD.COD_NDG_K4F        = F.COD_NDG_DEBI
		/*</staticWhere>
		<where varID="CodSocriferimento">
			WHERE F.COD_SOCRIFERIMENTO = $CodSocriferimento$
		</where>
		<where varID="CodEnteAzie">
  			AND SC.COD_ENTE_AZIE		= $CodEnteAzie$
		</where>
		<where varID="CodNdgGest">
  			AND SC.COD_NDG_GEST         	= $CodNdgGest$
		</where>	
		<where varID="CodEnteRecuDebi">
  			AND SD.COD_ENTE_RECU_DEBI  	= $CodEnteRecuDebi$
		</where>	
		<where varID="CodNdgCede">
  			AND F.COD_NDG_CEDE		= $CodNdgCede$
		</where>		
		<where varID="CodNdgDebi">
  			AND F.COD_NDG_DEBI		= $CodNdgDebi$
		</where>
		<where varID="FlgbSegm">
  			AND COALESCE(SCG.COD_TIPO_SEGM_GEST, ' ')  = $CodTipoSegm$
		</where>		
		<where varID="FlgbEsclSegm">
  			AND COALESCE(SCG.COD_TIPO_SEGM_GEST, ' ')  
		</where>		
		<staticWhere>*/
	             GROUP BY      
	                   F.COD_NDG_DEBI      
	                   ,SD.DES_RAGI_SOCL      
	                   ,SD.COD_STAT_RISC
	                   ,SD.COD_TIPO_RATG
	                   ,SD.COD_RATG 
	                   ,T.IMP_TURN_PREC
					   ,T.IMP_INCA_PREC
						,SCD.COD_NDC_LF
						,SCD.COD_MDS
						,SCD.DES_MDS
						,SCD.COD_AREA_TER_SEG
						,SCD.DES_AREA_TER_SEG
						,SCD.COD_DIR_TERR_SEG
						,SCD.DES_DIR_TERR_SEG
						,SCD.COD_FILIALE_SEG
						,SCD.DES_FILIALE_SEG
						,SCD.COD_AREA_TER_ANAG
						,SCD.DES_AREA_TER_ANAG
						,SCD.COD_DIR_TER_ANAG
						,SCD.DES_DIR_TER_ANAG
						,SCD.COD_ANA_FIL_SEG
						,SCD.DES_ANA_FIL_SEG
	             HAVING (      
	                     SUM(F.IMP_SCAD_01)       
	                  OR SUM(F.IMP_SCAD_02)       
	                  OR SUM(F.IMP_SCAD_03)      
	                  OR SUM(F.IMP_SCAD_04)      
	                  OR SUM(F.IMP_SCAD_05)       
	                  OR SUM(F.IMP_SCAD_06)     
	                  OR SUM(F.IMP_ASCA_01)     
	                  OR SUM(F.IMP_ASCA_02)     
	                  OR SUM(F.IMP_ASCA_03)      
	                  OR SUM(F.IMP_ASCA_41)      
	                  OR SUM(F.IMP_ASCA_42)     
	                  OR SUM(F.IMP_SCAD_RICO_01)      
	                  OR SUM(F.IMP_SCAD_RICO_02)       
	                  OR SUM(F.IMP_SCAD_RICO_03)       
	                  OR SUM(F.IMP_SCAD_RICO_04)       
	                  OR SUM(F.IMP_SCAD_RICO_05)       
	                  OR SUM(F.IMP_SCAD_RICO_06) 
	                  OR SUM(F.IMP_ASCA_RICO_01)      
	                  OR SUM(F.IMP_ASCA_RICO_02)    
	                  OR SUM(F.IMP_ASCA_RICO_03)      
	                  OR SUM(F.IMP_ASCA_RICO_41)       
	                  OR SUM(F.IMP_ASCA_RICO_42) 
					  OR SUM(COALESCE(T.IMP_TURN_PREC, 0)) 
					  OR SUM(COALESCE(T.IMP_INCA_PREC, 0)) 
		/*</staticWhere>
		<where varID="FlgbScadS2">*/
					  OR SUM(F.IMP_TOCA_GG_CORR) 
					  OR SUM(F.IMP_INCA_NO_DILA + F.IMP_INCA_DILA)
		--</where>
		--<where varID="FlgbScadDFS">
					  OR SUM(FF.IMP_TOCA_GG_CORR) 
					  OR SUM(FF.IMP_INCA_NO_DILA + FF.IMP_INCA_DILA)
		--</where>
		--<staticWhere>					  
	                   )
	             ORDER BY F.COD_NDG_DEBI
		--</staticWhere>
	--</sql>
	--<interface>
            <infields>
		<field name="CodSocriferimento"	type= "text" mandatory="yes"/>
		<field name="CodEnteAzie"       type= "text"/>
		<field name="CodNdgGest"      	type= "number"/>
		<field name="CodEnteRecuDebi"   type= "number"/>
		<field name="CodNdgDebi"   	type= "number"/>
		<field name="CodNdgCede"   	type= "number"/>
		<field name="FlgbScadS2"   type= "text" />
		<field name="FlgbScadDFS"   type= "text" />
		<field name="CodTipoSegm"   type= "text" />
		<field name="FlgbSegm" 	    type= "text" />
		<field name="FlgbEsclSegm"  type= "text" />
		<field name="Anno"   		type= "text" />
		<field name="Mese"		   	type= "text" />
            </infields>
            <outfields>
                <field name="COD_NDG_DEBI            " typeGRID="YES" typeEXCEL="YES"/>
                <field name="DES_RAGI_SOCL_DEBI      " typeGRID="YES" typeEXCEL="YES"/>                
                <field name="COD_STAT_RISC_DEBI      " typeGRID="YES" typeEXCEL="YES"/>                
                <field name="COD_TIPO_RATG_DEBI	     " typeGRID="YES" typeEXCEL="YES"/>                
                <field name="COD_RATG_DEBI 			 " typeGRID="YES" typeEXCEL="YES"/>                
                <field name="IMP_SCAD_01             " typeGRID="YES" typeEXCEL="YES" typeAmount="YES"/>                
                <field name="IMP_SCAD_02             " typeGRID="YES" typeEXCEL="YES" typeAmount="YES"/>                
                <field name="IMP_SCAD_03             " typeGRID="YES" typeEXCEL="YES" typeAmount="YES"/>                
                <field name="IMP_SCAD_04             " typeGRID="YES" typeEXCEL="YES" typeAmount="YES"/>
                <field name="IMP_SCAD_05             " typeGRID="YES" typeEXCEL="YES" typeAmount="YES"/>
                <field name="IMP_SCAD_06             " typeGRID="YES" typeEXCEL="YES" typeAmount="YES"/>
                <field name="IMP_SCAD_TOTA           " typeGRID="YES" typeEXCEL="YES" typeAmount="YES"/>                
                <field name="IMP_ASCA_01             " typeGRID="YES" typeEXCEL="YES" typeAmount="YES"/>                
                <field name="IMP_ASCA_02             " typeGRID="YES" typeEXCEL="YES" typeAmount="YES"/>                
                <field name="IMP_ASCA_03             " typeGRID="YES" typeEXCEL="YES" typeAmount="YES"/>                
                <field name="IMP_ASCA_41             " typeGRID="YES" typeEXCEL="YES" typeAmount="YES"/>
                <field name="IMP_ASCA_42             " typeGRID="YES" typeEXCEL="YES" typeAmount="YES"/>
                <field name="IMP_TOTA_ASCA           " typeGRID="YES" typeEXCEL="YES" typeAmount="YES"/>               
                <field name="IMP_CDEB				 " typeGRID="YES" typeEXCEL="YES" typeAmount="YES"/>                
				<field name="IMP_SCAD_RICO_01        " typeGRID="YES" typeEXCEL="YES" typeAmount="YES"/>                
                <field name="IMP_SCAD_RICO_02        " typeGRID="YES" typeEXCEL="YES" typeAmount="YES"/>                
                <field name="IMP_SCAD_RICO_03        " typeGRID="YES" typeEXCEL="YES" typeAmount="YES"/>                
                <field name="IMP_SCAD_RICO_04        " typeGRID="YES" typeEXCEL="YES" typeAmount="YES"/>
                <field name="IMP_SCAD_RICO_05        " typeGRID="YES" typeEXCEL="YES" typeAmount="YES"/>
                <field name="IMP_SCAD_RICO_06        " typeGRID="YES" typeEXCEL="YES" typeAmount="YES"/>
                <field name="IMP_TOTA_SCAD_RICO      " typeGRID="YES" typeEXCEL="YES" typeAmount="YES"/>                
				<field name="IMP_ASCA_RICO_01        " typeGRID="YES" typeEXCEL="YES" typeAmount="YES"/>                
                <field name="IMP_ASCA_RICO_02        " typeGRID="YES" typeEXCEL="YES" typeAmount="YES"/>                
                <field name="IMP_ASCA_RICO_03        " typeGRID="YES" typeEXCEL="YES" typeAmount="YES"/>                
                <field name="IMP_ASCA_RICO_41        " typeGRID="YES" typeEXCEL="YES" typeAmount="YES"/>
                <field name="IMP_ASCA_RICO_42        " typeGRID="YES" typeEXCEL="YES" typeAmount="YES"/>
                <field name="IMP_TOTA_ASCA_RICO      " typeGRID="YES" typeEXCEL="YES" typeAmount="YES"/>
                <field name="IMP_TURN_12MM		     " typeGRID="YES" typeEXCEL="YES" typeAmount="YES"/>
                <field name="IMP_TURN_MESE		     " typeGRID="YES" typeEXCEL="YES" typeAmount="YES"/>
                <field name="IMP_INCA_12MM		     " typeGRID="YES" typeEXCEL="YES" typeAmount="YES"/>
                <field name="IMP_INCA_MESE		     " typeGRID="YES" typeEXCEL="YES" typeAmount="YES"/>
				<field name="COD_NDC_LF			" typeGRID="YES" typeEXCEL="YES"/>
				<field name="COD_MDS			" typeGRID="YES" typeEXCEL="YES"/>
				<field name="DES_MDS			" typeGRID="YES" typeEXCEL="YES"/>
				<field name="COD_AREA_TER_SEG	" typeGRID="YES" typeEXCEL="YES"/>
				<field name="DES_AREA_TER_SEG	" typeGRID="YES" typeEXCEL="YES"/>
				<field name="COD_DIR_TERR_SEG	" typeGRID="YES" typeEXCEL="YES"/>
				<field name="DES_DIR_TERR_SEG	" typeGRID="YES" typeEXCEL="YES"/>
				<field name="COD_FILIALE_SEG	" typeGRID="YES" typeEXCEL="YES"/>
				<field name="DES_FILIALE_SEG	" typeGRID="YES" typeEXCEL="YES"/>
				<field name="COD_AREA_TER_ANAG	" typeGRID="YES" typeEXCEL="YES"/>
				<field name="DES_AREA_TER_ANAG	" typeGRID="YES" typeEXCEL="YES"/>
				<field name="COD_DIR_TER_ANAG	" typeGRID="YES" typeEXCEL="YES"/>
				<field name="DES_DIR_TER_ANAG	" typeGRID="YES" typeEXCEL="YES"/>
				<field name="COD_ANA_FIL_SEG	" typeGRID="YES" typeEXCEL="YES"/>
				<field name="DES_ANA_FIL_SEG	" typeGRID="YES" typeEXCEL="YES"/>
            </outfields>
        </interface>
    </query>
</xml-querydefiner>
</beans>

--oustanding
SELECT NUM_PR_LIN_CREDITO, SUM(IMP_SALD_CDEB) AS OUSTANDING FROM FOPT_PARTITA
WHERE COD_SOCRIFERIMENTO = '15'
AND COD_TIPO_PRTT in ('P01','P03')
AND DAT_CHIU_DEBI_FCTG IS NULL
GROUP by NUM_PR_LIN_CREDITO