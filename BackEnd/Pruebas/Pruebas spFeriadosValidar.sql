USE HorasExtSup
GO

--CREATE PROCEDURE spFeriadosValidar
DECLARE
	 @fecha		date
	,@localidad	int
	,@feriado	bit			--OUTPUT
--AS
-----------------------------------------------------------------------------------------------------------------------------------------------------
SELECT
	 @fecha		= '2017-09-01'
	,@localidad	= 23
-----------------------------------------------------------------------------------------------------------------------------------------------------
BEGIN
	IF EXISTS (
		SELECT	1
		FROM	BIOMETRICO.TCONTROL.dbo.TBL_FESTIVOS FES
		WHERE	FES.D_FESTIVO = @fecha
		AND		(FES.D_LOCALIDAD = @localidad OR FES.D_LOCALIDAD = 0)
	)
	BEGIN
		SET @feriado = 1 --SI EXISTE
	END
	ELSE
	BEGIN
		SET @feriado = 0 --NO EXISTE
	END
	--SELECT @feriado AS '@feriado'
END
-----------------------------------------------------------------------------------------------------------------------------------------------------
/*
DECLARE @feriado	bit
EXEC spFeriadosValidar
	 @fecha		= '2017-09-01'
	,@localidad	= 23
	,@feriado	= @feriado OUTPUT
SELECT @feriado AS '@feriado'
*/
-----------------------------------------------------------------------------------------------------------------------------------------------------
-- SELECT TOP 100 * FROM [BIOMETRICO].[TCONTROL].[dbo].[TBL_FESTIVOS]
-- BIOMETRICO.TCONTROL.dbo.sp_help TBL_FESTIVOS
-----------------------------------------------------------------------------------------------------------------------------------------------------
