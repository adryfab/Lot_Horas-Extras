USE HorasExtSup
GO

-- ##SUMMARY Consulta información basica del empleado
-- ##AUTHOR  14/Sep/2017 Adriana Martinez
-- ##REMARKS 

--DROP PROCEDURE spDatosEmpleadoRecuperar

CREATE PROCEDURE spDatosEmpleadoRecuperar
	@UsuarioId VARCHAR(50)
AS
BEGIN
	--Obtiene el codigo del empleado
	DECLARE @CodEmp int
	--SELECT	@CodEmp	 = CodigoEmp
	--FROM	tbEmpleado
	--WHERE	UsuarioId = @UsuarioId
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
	SELECT	  @UsuarioId AS 'CodigoEmp'
			, PER.anio AS 'Anio'
			, PER.periodo AS 'Periodo'
			, PER.FechaInicial AS 'FechaInicial'
			, PER.FechaFinal AS 'FechaFinal'
	FROM	#tbPeriodo	AS PER 

	DROP TABLE #tbPeriodo 
END
GO
