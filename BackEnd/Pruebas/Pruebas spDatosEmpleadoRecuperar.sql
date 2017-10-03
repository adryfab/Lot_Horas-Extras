USE HorasExtSup
GO

--CREATE PROCEDURE spDatosEmpleadoRecuperar
DECLARE
	@UsuarioId VARCHAR(50)
--AS
---------------------------------------------------------------------------------------------------
SELECT
	@UsuarioId = '012042'--'cguznay'
---------------------------------------------------------------------------------------------------
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

	--DATOS DEL EMPLEADO
	SELECT	  MAX(TBL.EMP_ID) AS 'CodigoEmp'
			, MAX(PER.anio) AS 'Anio'
			, MAX(PER.periodo) AS 'Periodo'
			, MAX(PER.FechaInicial) AS 'FechaInicial'
			, MAX(PER.FechaFinal) AS 'FechaFinal'
	FROM	BIOMETRICO.TCONTROL.dbo.TBL_ASISTENCIA TBL
	INNER	JOIN #tbPeriodo	AS PER 
	ON		TBL.Fecha_Ingreso between PER.FechaInicial and PER.FechaFinal
	WHERE	TBL.EMP_ID = @CodEmp --@EmpId
	AND		(TBL.min_200 > 0 OR TBL.min_150 > 0)

	DROP TABLE #tbPeriodo 
END
GO
---------------------------------------------------------------------------------------------------
/*
EXEC spDatosEmpleadoRecuperar
@UsuarioId = '012042'--'cguznay'
*/
---------------------------------------------------------------------------------------------------
