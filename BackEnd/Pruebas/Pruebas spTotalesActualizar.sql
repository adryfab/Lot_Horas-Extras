USE HorasExtSup
GO

-- spTotalesActualizar
DECLARE 
	 @UsuarioId		varchar(50) 
	,@InfoXml		xml
-----------------------------------------------------------------------------------------------------------------------------------------------------
SELECT  @UsuarioId = 'amartinez'
SELECT	@InfoXml = N'<TOTHOE CODEMP="9275" ANIOPE="2017" PERIOD="9" TOH050="7" TOM050="45" TOH100="1" TOM100="20" /> '
-----------------------------------------------------------------------------------------------------------------------------------------------------
BEGIN TRY
	BEGIN TRAN

	/*
	DELETE	AP
	FROM	tbAprobaciones AS AP
	INNER	JOIN @InfoXml.nodes('/TOTHOE')	AS M(X)
	ON		AP.CodigoEmp = M.X.value('@CODEMP', 'int')
	AND		AP.Anio = M.X.value('@ANIOPE', 'int')
	AND		AP.PeriodoId = M.X.value('@PERIOD', 'int')

	INSERT INTO tbAprobaciones
	(
		 CodigoEmp 
		,Anio 
		,PeriodoId 
		,TotalHoras50 
		,TotalMinutos50 
		,TotalHoras100 
		,TotalMinutos100 
		,FechaRegistro 
		,UsuarioRegistro 
		,UsuarioSuper
		,FechaSuper
		,UsuarioJefe
		,Fechajefe
	)*/
	SELECT	 M.X.value('@CODEMP', 'int') AS 'CodigoEmp'
			,M.X.value('@ANIOPE', 'int') AS 'Anio'
			,M.X.value('@PERIOD', 'int') AS 'PeriodoId'
			,M.X.value('@TOH050', 'smallint') AS 'TotalHoras50'
			,M.X.value('@TOM050', 'smallint') AS 'TotalMinutos50'
			,M.X.value('@TOH100', 'smallint') AS 'TotalHoras100'
			,M.X.value('@TOM100', 'smallint') AS 'TotalMinutos100'
			,GETDATE()		AS 'FechaRegistro'
			,@UsuarioId		AS 'UsuarioRegistro'
			--Las aprobaciones previas se borran si se modifica algun registro
			,NULL			AS 'UsuarioSuper'
			,NULL			AS 'FechaSuper'
			,NULL			AS 'UsuarioJefe'
			,NULL			AS 'Fechajefe'
	FROM @InfoXml.nodes('/TOTHOE') AS M(X) 
	
	--Se procesa la transacción.		
    IF @@TRANCOUNT > 0 
	BEGIN
		COMMIT  TRAN 
	END
END TRY
BEGIN CATCH
	--En caso de error se realiza un rollback de la transaccion y se ejecuta el spError.
	IF @@TRANCOUNT > 0 
       ROLLBACK TRAN        
END CATCH
-----------------------------------------------------------------------------------------------------------------------------------------------------
-- SELECT * FROM tbAprobaciones
