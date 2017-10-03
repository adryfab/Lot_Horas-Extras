USE HorasExtSup
GO

-- ##SUMMARY Elimina la información registrada por el usuario en la tabla de HorasExtras
-- ##AUTHOR  12/Sep/2017 Adriana Martinez
-- ##REMARKS 

--CREATE PROCEDURE spHorasExtrasEliminar
DECLARE
	 @UsuarioId		varchar(50) 
	,@InfoXml		xml
--AS
-----------------------------------------------------------------------------------------------------------------------------------------------------
SELECT
	 @UsuarioId		= 'cguznay'
	,@InfoXml		= N''
-----------------------------------------------------------------------------------------------------------------------------------------------------
BEGIN TRY
	BEGIN TRAN
	--Se realiza la eliminacion
	DELETE	HE
	FROM	tbHorasExtras AS HE
	INNER	JOIN @InfoXml.nodes('/HOREXT')	AS M(X)
	ON		HE.HorasExtrasId	= M.X.value('@HOREXT', 'bigint')
	AND		HE.UsuarioId		= @UsuarioId

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
GO
