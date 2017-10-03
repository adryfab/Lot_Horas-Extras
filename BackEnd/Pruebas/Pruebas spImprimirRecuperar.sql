USE HorasExtSup
GO

--spImprimirRecuperar
DECLARE
	 @UsuarioId varchar(50) --= NULL
-----------------------------------------------------------------------------------------------------------------------------------------------------
SELECT @UsuarioId = '012042'--cguznay --'009275'--glavayen 
-----------------------------------------------------------------------------------------------------------------------------------------------------
BEGIN
	--Obtiene el codigo del empleado
	DECLARE @CodEmp int
	SELECT @CodEmp = @UsuarioId

	--Obtiene el ultimo periodo 
	SELECT	 TOP 1 
			 anio AS 'anio'
			,periodo AS 'periodo'
			,fecha_inicial AS 'FechaInicial'
			,fecha_final AS 'FechaFinal'
	INTO 	#tbPeriodo 
	FROM BIOMETRICO.TCONTROL.dbo.TBL_PERIODO 
	ORDER BY anio DESC, periodo DESC

	--Informacion de la cabecera
	SELECT	 PER.FechaInicial
			,PER.FechaFinal
	FROM #tbPeriodo PER

	SELECT 
			 NOM.NOMINA_NOM + ' ' + NOM.NOMINA_APE AS 'COLAB'
			,NOM.NOMINA_CAL1 AS 'CARGO'
			,NOM.NOMINA_AREA1 AS 'LOCALIDAD'
			,NOM.NOMINA_DEP1 AS 'DPTO'
	FROM BIOMETRICO.ONLYCONTROL.dbo.NOMINA NOM
	WHERE NOM.NOMINA_ID = @CodEmp

	--Informacion del biometrico y registrado 50% SUPLEMENTARIAS
	SELECT	row_number() over(order by X.Fecha) AS 'Num', X.*
	FROM	(
		SELECT	  
				  CONVERT(VARCHAR, TBL.Fecha_Ingreso, 111) AS 'Fecha'
				, TBL.Fecha_Ingreso +' '+ CONVERT(VARCHAR(5), TBL.Hora_Ingreso , 114) AS 'Ingreso'
				, TBL.Fecha_Ingreso +' '+ CONVERT(VARCHAR(5), TBL.Hora_Salida , 114) AS 'Salida'
				, TBL.Fecha_Ingreso +' '+ CONVERT(VARCHAR(5), TBL.Horas_Laboradas, 114) AS 'Laborado'
				, TBL.Fecha_Ingreso +' '+ RIGHT( convert(char(8), dateadd(second, TBL.min_150, ''), 114) ,5) AS 'Horas50'
				, ISNULL(HOR.Descripcion,'') AS 'Justificativo'
		FROM	BIOMETRICO.TCONTROL.dbo.TBL_ASISTENCIA TBL
		INNER	JOIN #tbPeriodo	AS PER 
		ON		TBL.Fecha_Ingreso between PER.FechaInicial and PER.FechaFinal
		LEFT	JOIN tbHorasExtras AS HOR
		ON		HOR.CodigoEmp = TBL.EMP_ID
		AND		HOR.Fecha = TBL.Fecha_Ingreso
		AND		CONVERT(VARCHAR(5),TBL.Hora_Ingreso, 114) = CONVERT(VARCHAR(5),HOR.HoraIngreso, 114)
		WHERE	TBL.EMP_ID = @CodEmp
		AND		(TBL.min_150 > 0)
		AND NOT EXISTS (SELECT 1 FROM tbHorasExtras EX WHERE EX.CodigoEmp = TBL.EMP_ID AND EX.Fecha = TBL.Fecha_Ingreso AND EX.Activo = 0)
		UNION
		SELECT
				  HE.Fecha AS 'Fecha'
				, CONVERT(VARCHAR,HE.Fecha) +' '+ CONVERT(VARCHAR(5),HE.HoraIngreso,114) AS 'Ingreso'
				, CONVERT(VARCHAR,HE.Fecha) +' '+ CONVERT(VARCHAR(5),HE.HoraSalida,114) AS 'Salida'
				, CONVERT(VARCHAR,HE.Fecha) +' '+ CONVERT(VARCHAR(5),HE.HoraLaborado,114) AS 'Laborado'
				, CONVERT(VARCHAR,HE.Fecha) +' '+ CONVERT(VARCHAR(5),HE.Horas50,114) AS 'Horas50'
				, HE.Descripcion AS 'Justificativo'
		FROM	HorasExtSup.dbo.tbHorasExtras HE
		INNER	JOIN #tbPeriodo	AS PER 
		ON		PER.anio = HE.Anio
		AND		PER.periodo = HE.PeriodoId
		WHERE	HE.Activo = 1
		AND		HE.CodigoEmp = @CodEmp 
		AND		DATEDIFF(SECOND, '00:00', HE.Horas50) > 0
	) AS X

	--Informacion del biometrico y registrado al 100% EXTRAORDINARIAS
	SELECT	row_number() over(order by X.Fecha) AS 'Num', X.*
	FROM	(
		SELECT	  
				  CONVERT(VARCHAR, TBL.Fecha_Ingreso, 111) AS 'Fecha'
				, TBL.Fecha_Ingreso +' '+ CONVERT(VARCHAR(5), TBL.Hora_Ingreso , 114) AS 'Ingreso'
				, TBL.Fecha_Ingreso +' '+ CONVERT(VARCHAR(5), TBL.Hora_Salida , 114) AS 'Salida'
				, TBL.Fecha_Ingreso +' '+ CONVERT(VARCHAR(5), TBL.Horas_Laboradas, 114) AS 'Laborado'
				, TBL.Fecha_Ingreso +' '+ RIGHT( convert(char(8), dateadd(second, TBL.min_200, ''), 114) ,5) AS 'Horas100'
				, ISNULL(HOR.Descripcion,'') AS 'Justificativo'
		FROM	BIOMETRICO.TCONTROL.dbo.TBL_ASISTENCIA TBL
		INNER	JOIN #tbPeriodo	AS PER 
		ON		TBL.Fecha_Ingreso between PER.FechaInicial and PER.FechaFinal
		LEFT	JOIN tbHorasExtras AS HOR
		ON		HOR.CodigoEmp = TBL.EMP_ID
		AND		HOR.Fecha = TBL.Fecha_Ingreso
		AND		CONVERT(VARCHAR(5),TBL.Hora_Ingreso, 114) = CONVERT(VARCHAR(5),HOR.HoraIngreso, 114)
		WHERE	TBL.EMP_ID = @CodEmp
		AND		(TBL.min_200 > 0)
		AND NOT EXISTS (SELECT 1 FROM tbHorasExtras EX WHERE EX.CodigoEmp = TBL.EMP_ID AND EX.Fecha = TBL.Fecha_Ingreso AND EX.Activo = 0)
		UNION
		SELECT
				 HE.Fecha AS 'Fecha'
				, CONVERT(VARCHAR,HE.Fecha) +' '+ CONVERT(VARCHAR(5),HE.HoraIngreso,114) AS 'Ingreso'
				, CONVERT(VARCHAR,HE.Fecha) +' '+ CONVERT(VARCHAR(5),HE.HoraSalida,114) AS 'Salida'
				, CONVERT(VARCHAR,HE.Fecha) +' '+ CONVERT(VARCHAR(5),HE.HoraLaborado,114) AS 'Laborado'
				, CONVERT(VARCHAR,HE.Fecha) +' '+ CONVERT(VARCHAR(5),HE.Horas100,114) AS 'Horas100'
				, HE.Descripcion AS 'Justificativo'
		FROM	HorasExtSup.dbo.tbHorasExtras HE
		INNER	JOIN #tbPeriodo	AS PER 
		ON		PER.anio = HE.Anio
		AND		PER.periodo = HE.PeriodoId
		WHERE	HE.Activo = 1
		AND		HE.CodigoEmp = @CodEmp 
		AND		DATEDIFF(SECOND, '00:00', HE.Horas100) > 0
	) AS X

	--Informacion de los superiores
	SELECT 
			 NOM.NOMINA_NOM + ' ' + NOM.NOMINA_APE AS 'COLAB'
			,NOM.NOMINA_AREA 
			,NOM.NOMINA_DEP 
			,DEP.DEP_EM
			,DNOM.NOMINA_NOM + ' ' + DNOM.NOMINA_APE AS 'SUPERVISOR'
			,ARE.AREA_EM
			,ANOM.NOMINA_NOM + ' ' + ANOM.NOMINA_APE AS 'JEFE'
	FROM BIOMETRICO.ONLYCONTROL.dbo.NOMINA NOM
	INNER JOIN BIOMETRICO.ONLYCONTROL.dbo.DPTO DEP
	ON	DEP.DEP_ID = NOM.NOMINA_DEP 
	LEFT JOIN BIOMETRICO.ONLYCONTROL.dbo.NOMINA DNOM
	ON	DNOM.NOMINA_ID = DEP.DEP_EM
	INNER JOIN BIOMETRICO.ONLYCONTROL.dbo.AREA ARE
	ON ARE.AREA_ID = NOM.NOMINA_AREA 
	LEFT JOIN BIOMETRICO.ONLYCONTROL.dbo.NOMINA ANOM
	ON ANOM.NOMINA_ID = ARE.AREA_EM
	WHERE NOM.NOMINA_ID = @CodEmp
	
	--Suma horas del 50% SUPLEMENTARIO
	SELECT RIGHT( convert(char(8), dateadd(second, SUM(X.Horas50), ''), 114) ,5) AS 'TotalHoras50'
	FROM
	(
		SELECT	TBL.min_150 AS 'Horas50'
		FROM	BIOMETRICO.TCONTROL.dbo.TBL_ASISTENCIA TBL
		INNER	JOIN #tbPeriodo	AS PER 
		ON		TBL.Fecha_Ingreso between PER.FechaInicial and PER.FechaFinal
		LEFT	JOIN tbHorasExtras AS HOR
		ON		HOR.CodigoEmp = TBL.EMP_ID
		AND		HOR.Fecha = TBL.Fecha_Ingreso
		AND		CONVERT(VARCHAR(5),TBL.Hora_Ingreso, 114) = CONVERT(VARCHAR(5),HOR.HoraIngreso, 114)
		WHERE	TBL.EMP_ID = @CodEmp
		AND		(TBL.min_150 > 0)
		AND NOT EXISTS (SELECT 1 FROM tbHorasExtras EX WHERE EX.CodigoEmp = TBL.EMP_ID AND EX.Fecha = TBL.Fecha_Ingreso AND EX.Activo = 0)
		UNION
		SELECT	DATEDIFF(MINUTE, '00:00', HE.Horas50) AS 'Horas50'
		FROM	HorasExtSup.dbo.tbHorasExtras HE
		INNER	JOIN #tbPeriodo	AS PER 
		ON		PER.anio = HE.Anio
		AND		PER.periodo = HE.PeriodoId
		WHERE	HE.Activo = 1
		AND		HE.CodigoEmp = @CodEmp 
		AND		DATEDIFF(SECOND, '00:00', HE.Horas50) > 0
	) AS X

	--Suma horas del 100% EXTRAORDINARIO
	SELECT RIGHT( convert(char(8), dateadd(second, SUM(X.Horas100), ''), 114) ,5) AS 'TotalHoras100'
	FROM
	(
		SELECT	TBL.min_200 AS 'Horas100'
		FROM	BIOMETRICO.TCONTROL.dbo.TBL_ASISTENCIA TBL
		INNER	JOIN #tbPeriodo	AS PER 
		ON		TBL.Fecha_Ingreso between PER.FechaInicial and PER.FechaFinal
		LEFT	JOIN tbHorasExtras AS HOR
		ON		HOR.CodigoEmp = TBL.EMP_ID
		AND		HOR.Fecha = TBL.Fecha_Ingreso
		AND		CONVERT(VARCHAR(5),TBL.Hora_Ingreso, 114) = CONVERT(VARCHAR(5),HOR.HoraIngreso, 114)
		WHERE	TBL.EMP_ID = @CodEmp
		AND		(TBL.min_200 > 0)
		AND NOT EXISTS (SELECT 1 FROM tbHorasExtras EX WHERE EX.CodigoEmp = TBL.EMP_ID AND EX.Fecha = TBL.Fecha_Ingreso AND EX.Activo = 0)
		UNION
		SELECT	DATEDIFF(MINUTE, '00:00', HE.Horas100) AS 'Horas100'
		FROM	HorasExtSup.dbo.tbHorasExtras HE
		INNER	JOIN #tbPeriodo	AS PER 
		ON		PER.anio = HE.Anio
		AND		PER.periodo = HE.PeriodoId
		WHERE	HE.Activo = 1
		AND		HE.CodigoEmp = @CodEmp 
		AND		DATEDIFF(SECOND, '00:00', HE.Horas100) > 0
	) AS X

	DROP TABLE #tbPeriodo

END

-----------------------------------------------------------------------------------------------------------------------------------------------------
/*
EXEC spImprimirRecuperar
@UsuarioId = '012042'--cguznay --'009275'--glavayen 
*/
-----------------------------------------------------------------------------------------------------------------------------------------------------
-- SELECT TOP 10 * FROM BIOMETRICO.ONLYCONTROL.dbo.NOMINA
-- SELECT TOP 10 * FROM BIOMETRICO.ONLYCONTROL.dbo.DPTO
-- SELECT TOP 10 * FROM BIOMETRICO.ONLYCONTROL.dbo.AREA
