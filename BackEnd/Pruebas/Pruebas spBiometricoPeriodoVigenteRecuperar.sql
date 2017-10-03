USE HorasExtSup
GO

--spBiometricoPeriodoVigenteRecuperar
DECLARE
	 @UsuarioId varchar(50) --= NULL
-----------------------------------------------------------------------------------------------------------------------------------------------------
SELECT @UsuarioId = '009275'--glavayen --'012042'--cguznay 
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

	-- CREATE TABLE #BIOMETRICO
	-- (
		 -- CodigoEmp		nvarchar(12)	NULL
		-- ,Dia			varchar(3)		NULL
		-- ,Fecha			datetime		NULL
		-- ,Ingreso		datetime		NULL
		-- ,Salida			datetime		NULL
		-- ,Laborado		datetime		NULL
		-- ,Atrasado		datetime		NULL
		-- ,Anticipado		datetime		NULL
		-- ,Horas0			datetime		NULL
		-- ,Horas50		datetime		NULL
		-- ,Horas100		datetime		NULL
		-- ,Justificativo	varchar(max)	NULL
		-- ,HorasExtrasId	bigint			NULL
		-- ,Anio			smallint		NULL
		-- ,Periodo		smallint		NULL
		-- ,Activo			bit				NULL
		-- ,HorasPermiso	datetime		NULL
		-- ,HorasRecuperar	datetime		NULL
	-- )

	--Obtiene la informacion del biometrico
	--INSERT INTO #BIOMETRICO
	SELECT	  
			  TBL.EMP_ID AS 'CodigoEmp'
			, SUBSTRING(dbo.fnObtenerNombreDia(TBL.Fecha_Ingreso), 1, 3) AS 'Dia'
			, CONVERT(VARCHAR, TBL.Fecha_Ingreso, 111) AS 'Fecha'
			, TBL.Fecha_Ingreso +' '+ CONVERT(VARCHAR(5), TBL.Hora_Ingreso , 114) AS 'Ingreso'
			, TBL.Fecha_Ingreso +' '+ CONVERT(VARCHAR(5), TBL.Hora_Salida , 114) AS 'Salida'
			, TBL.Fecha_Ingreso +' '+ CONVERT(VARCHAR(5), TBL.Horas_Laboradas, 114) AS 'Laborado'
			, TBL.Fecha_Ingreso +' '+ RIGHT( convert(char(8), dateadd(second, TBL.min_AT, ''), 114) ,5) AS 'Atrasado' 
			, TBL.Fecha_Ingreso +' '+ RIGHT( convert(char(8), dateadd(second, TBL.min_SA, ''), 114) ,5) AS 'Anticipado'
			, TBL.Fecha_Ingreso +' '+ RIGHT( convert(char(8), dateadd(second, TBL.min_100, ''), 114) ,5) AS 'Horas0'
			, TBL.Fecha_Ingreso +' '+ RIGHT( convert(char(8), dateadd(second, TBL.min_150, ''), 114) ,5) AS 'Horas50'
			, TBL.Fecha_Ingreso +' '+ RIGHT( convert(char(8), dateadd(second, TBL.min_200, ''), 114) ,5) AS 'Horas100'
			, ISNULL(HOR.Descripcion,'') AS 'Justificativo'
			, ISNULL(HOR.HorasExtrasId,0) AS 'HorasExtrasId'
			, PER.anio AS 'Anio'
			, PER.periodo AS 'Periodo'
			, ISNULL(HOR.Activo,1) AS 'Activo'
			, TBL.Fecha_Ingreso +' '+ '00:00' AS 'HorasPermiso'
			, TBL.Fecha_Ingreso +' '+ '00:00'  AS 'HorasRecuperar'
	FROM	BIOMETRICO.TCONTROL.dbo.TBL_ASISTENCIA TBL
	INNER	JOIN #tbPeriodo	AS PER 
	ON		TBL.Fecha_Ingreso between PER.FechaInicial and PER.FechaFinal
	LEFT	JOIN tbHorasExtras AS HOR
	ON		HOR.CodigoEmp = TBL.EMP_ID
	AND		HOR.Fecha = TBL.Fecha_Ingreso
	AND		CONVERT(VARCHAR(5),TBL.Hora_Ingreso, 114) = CONVERT(VARCHAR(5),HOR.HoraIngreso, 114)
	WHERE	TBL.EMP_ID = @CodEmp
	AND		(TBL.min_200 > 0 OR TBL.min_150 > 0)
	AND NOT EXISTS (SELECT 1 FROM tbHorasExtras EX WHERE EX.CodigoEmp = TBL.EMP_ID AND EX.Fecha = TBL.Fecha_Ingreso AND EX.Activo = 0)

	UNION

	SELECT
			  HE.CodigoEmp AS 'CodigoEmp'
			, SUBSTRING(dbo.fnObtenerNombreDia(HE.Fecha), 1, 3) AS 'Dia'
			, HE.Fecha AS 'Fecha'
			, CONVERT(VARCHAR,HE.Fecha) +' '+ CONVERT(VARCHAR(5),HE.HoraIngreso,114) AS 'Ingreso'
			, CONVERT(VARCHAR,HE.Fecha) +' '+ CONVERT(VARCHAR(5),HE.HoraSalida,114) AS 'Salida'
			, CONVERT(VARCHAR,HE.Fecha) +' '+ CONVERT(VARCHAR(5),HE.HoraLaborado,114) AS 'Laborado'
			, CONVERT(VARCHAR,HE.Fecha) +' '+ CONVERT(VARCHAR(5),HE.HoraAtrasado,114) AS 'Atrasado' 
			, CONVERT(VARCHAR,HE.Fecha) +' '+ CONVERT(VARCHAR(5),HE.HoraAnticipado,114) AS 'Anticipado'
			, CONVERT(VARCHAR,HE.Fecha) +' '+ CONVERT(VARCHAR(5),HE.Horas0,114) AS 'Horas0'
			, CONVERT(VARCHAR,HE.Fecha) +' '+ CONVERT(VARCHAR(5),HE.Horas50,114) AS 'Horas50'
			, CONVERT(VARCHAR,HE.Fecha) +' '+ CONVERT(VARCHAR(5),HE.Horas100,114) AS 'Horas100'
			, HE.Descripcion AS 'Justificativo'
			, HE.HorasExtrasId AS 'HorasExtrasId'
			, HE.Anio AS 'Anio'
			, HE.PeriodoId AS 'Periodo'
			, ISNULL(HE.Activo,1) AS 'Activo'
			, CONVERT(VARCHAR,HE.Fecha) +' '+ CONVERT(VARCHAR(5),HE.HorasPermiso,114) AS 'HorasPermiso'
			, CONVERT(VARCHAR,HE.Fecha) +' '+ CONVERT(VARCHAR(5),HE.HorasRecuperar,114) AS 'HorasRecuperar'
	FROM HorasExtSup.dbo.tbHorasExtras HE
	INNER	JOIN #tbPeriodo	AS PER 
	ON		PER.anio = HE.Anio
	AND		PER.periodo = HE.PeriodoId
	WHERE HE.Activo = 1
	AND HE.CodigoEmp = @CodEmp 
	ORDER BY 3, 4

	SELECT * FROM #BIOMETRICO

	--DATOS DEL EMPLEADO
	SELECT	  @CodEmp AS 'CodigoEmp'
			, PER.anio AS 'Anio'
			, PER.periodo AS 'Periodo'
			, PER.FechaInicial AS 'FechaInicial'
			, PER.FechaFinal AS 'FechaFinal'
			, CASE WHEN ISNULL(UsuarioSuper,'') <> '' OR ISNULL(UsuarioJefe,'') <> '' THEN 1 ELSE 0 END AS 'Aprobado'
			, NOM.NOMINA_AREA1 AS 'Area'
			, NOM.NOMINA_AREA AS 'AreaId'
			, NOM.NOMINA_DEP1 AS 'Departamento'
			, NOM.NOMINA_DEP AS 'DepartamentoId'
	FROM	#tbPeriodo	AS PER 
	LEFT	JOIN HorasExtSup.dbo.tbAprobaciones APR
	ON		APR.CodigoEmp = @CodEmp 
	INNER	JOIN BIOMETRICO.ONLYCONTROL.dbo.NOMINA NOM
	ON		NOM.NOMINA_ID = @CodEmp
	AND		APR.Anio = PER.anio
	AND		APR.PeriodoId = PER.periodo

	----TOTALES
	--SELECT 
	--		(SUM(DATEPART(HOUR,Horas50))) AS 'Horas50'
	--FROM #BIOMETRICO

	DROP TABLE #tbPeriodo
	--DROP TABLE #BIOMETRICO
END
-----------------------------------------------------------------------------------------------------------------------------------------------------
/*
EXEC spBiometricoPeriodoVigenteRecuperar
--@UsuarioId = '012042'--cguznay
@UsuarioId = '009275'--glavayen 
*/
-----------------------------------------------------------------------------------------------------------------------------------------------------
-- SELECT * FROM HorasExtSup.dbo.tbHorasExtras
-- DELETE FROM HorasExtSup.dbo.tbHorasExtras
-- SELECT TOP 10 * FROM BIOMETRICO.TCONTROL.dbo.TBL_ASISTENCIA ORDER BY Fecha_Ingreso DESC
-- BIOMETRICO.TCONTROL.dbo.sp_help TBL_ASISTENCIA 
-- HorasExtSup.dbo.sp_help tbHorasExtras
-- BIOMETRICO.TCONTROL.dbo.sp_help TBL_PERIODO
-- SELECT top 10 * FROM BIOMETRICO.ONLYCONTROL.dbo.NOMINA WHERE NOMINA_ID = '009275'
-- SELECT * FROM BIOMETRICO.ONLYCONTROL.dbo.DPTO --SISTEMAS=OCAÑA DONOSO MARIA FERNANDA
-- SELECT * FROM BIOMETRICO.ONLYCONTROL.dbo.AREA --INFORMÁTICA=BARBERY MONTOYA ERNESTO ABRAHAM
-- Dep=112	Area=37	Nombre=RECURSOS HUMANOS
