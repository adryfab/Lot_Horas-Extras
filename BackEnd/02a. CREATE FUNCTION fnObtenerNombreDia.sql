USE HorasExtSup
GO

-- ##SUMMARY Obtiene el nombre del día dependiendo del parametro enviado.
-- ##SUMMARY Previamente la variable DATEFIRST debe estar seteada en uno (SET DATEFIRST 1)
-- ##AUTHOR  18/Ago/2017 - Alex Amador 
-- ##REMARKS 

--DROP FUNCTION fnObtenerNombreDia

CREATE FUNCTION fnObtenerNombreDia
(
	@Fecha		udFecha
)
RETURNS varchar(10)
AS
BEGIN

DECLARE @Valor			varchar(10)	
		,@NumeroDia	smallint 

	SET @NumeroDia = CASE WHEN @@DATEFIRST = 7 THEN 
								CASE WHEN datepart(dw,@Fecha) -1  = 0 
								     THEN 7 ELSE datepart(dw,@Fecha) -1  
								END  
						  ELSE datepart(dw,@Fecha) 
					 END

	SET	@Valor = CASE(@NumeroDia) 
					  WHEN 1 THEN 'Lunes'
					  WHEN 2 THEN 'Martes'
					  WHEN 3 THEN 'Miercoles'
					  WHEN 4 THEN 'Jueves'
					  WHEN 5 THEN 'Viernes'
					  WHEN 6 THEN 'Sábado'
					  WHEN 7 THEN 'Domingo'
					  ELSE 'ERROR' 
				END

	RETURN(@Valor);

END
GO
