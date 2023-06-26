/*1. Hacer una función que dado un artículo y un deposito devuelva un string que
indique el estado del depósito según el artículo. Si la cantidad almacenada es
menor al límite retornar “OCUPACION DEL DEPOSITO XX %” siendo XX el
% de ocupación. Si la cantidad almacenada es mayor o igual al límite retornar
“DEPOSITO COMPLETO”.*/

CREATE FUNCTION dbo.Ejercicio1 (@art varchar(8),@depo char(2))

RETURNS varchar(30)

AS
BEGIN 
	DECLARE @result DECIMAL(12,2)
	(
		SELECT @result = ISNULL((S.stoc_cantidad*100) / S.stoc_stock_maximo,0)
		FROM STOCK S
		WHERE S.stoc_producto = @art AND S.stoc_deposito = @depo
	)
RETURN
	CASE
		WHEN @result < 100
		THEN 
			('Ocupacion del Deposito: ' + CONVERT(varchar(10),@result) + '%')
		ELSE
			'Deposito Completo'
	END
END
GO



/*
SELECT dbo.Ejercicio1('00000102','00')

SELECT dbo.Ejercicio2('00000102','2011-18-08 00:00:00')
*/