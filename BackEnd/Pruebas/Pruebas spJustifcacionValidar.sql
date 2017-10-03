USE HorasExtSup
GO

--CREATE PROCEDURE spJustifcacionValidar
DECLARE
	 @UsuarioId 	VARCHAR(50) 
	,@Justificado	bit			--OUTPUT
--AS
-----------------------------------------------------------------------------------------------------------------------------------------------------
SELECT
	@UsuarioId = '012042'--cguznay --'009275'--glavayen 
-----------------------------------------------------------------------------------------------------------------------------------------------------
BEGIN
	--Obtiene el codigo del empleado
	DECLARE @CodEmp int
	SELECT	@CodEmp	 = @UsuarioId

	--Obtiene el ultimo periodo 
	SELECT	 TOP 1 
			 anio AS 'anio'
			,periodo AS 'periodo'
			,fecha_inicial AS 'FechaInicial'
			,fecha_final AS 'FechaFinal'
	INTO 	#tbPeriodo 
	FROM BIOMETRICO.TCONTROL.dbo.TBL_PERIODO 
	ORDER BY anio DESC, periodo DESC

	--Se añaden varias columnas por si despues se necesitan validaciones adicionales
	SELECT	  
			  TBL.EMP_ID AS 'CodigoEmp'
			, CONVERT(VARCHAR, TBL.Fecha_Ingreso, 111) AS 'Fecha'
			, TBL.Fecha_Ingreso +' '+ CONVERT(VARCHAR(5), TBL.Hora_Ingreso , 114) AS 'Ingreso'
			, TBL.Fecha_Ingreso +' '+ CONVERT(VARCHAR(5), TBL.Hora_Salida , 114) AS 'Salida'
			, ISNULL(HOR.Descripcion,'') AS 'Justificativo'
			, ISNULL(HOR.HorasExtrasId,0) AS 'HorasExtrasId'
			, PER.anio AS 'Anio'
			, PER.periodo AS 'Periodo'
			, ISNULL(HOR.Activo,1) AS 'Activo'
	INTO	#BIOMETRICO
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

	IF EXISTS(SELECT 1 FROM #BIOMETRICO WHERE HorasExtrasId = 0)
	BEGIN
		SELECT @Justificado = 0
	END
	ELSE
	BEGIN
		SELECT @Justificado = 1
	END

SELECT @Justificado

	DROP TABLE #tbPeriodo
	DROP TABLE #BIOMETRICO

END
---------------------------------------------------------------------------------------------------
/*
DECLARE	@Justificado	bit
EXEC spJustifcacionValidar
	 @UsuarioId 	= '009275'--glavayen --'012042'--cguznay 
	,@Justificado	= @Justificado OUTPUT
SELECT @Justificado
*/
---------------------------------------------------------------------------------------------------
