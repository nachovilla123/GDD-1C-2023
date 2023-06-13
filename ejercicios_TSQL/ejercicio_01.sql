-- este ejercicio esta corregido :D

/*
1. Hacer una función que dado un artículo y un deposito devuelva un string que
indique el estado del depósito según el artículo. Si la cantidad almacenada es
menor al límite retornar “OCUPACION DEL DEPOSITO XX %” siendo XX el
% de ocupación. Si la cantidad almacenada es mayor o igual al límite retornar
“DEPOSITO COMPLETO”.
*/
--SQL SERVER 

create function ej1(@articulo char(8),@deposito char(2))
RETURNS varchar(40)
AS
BEGIN

RETURN (SELECT case when stoc_cantidad >= ISNULL(S.stoc_stock_maximo,0) then 'DEPOSITO COMPLETO'
	else 'OCUPACION DEL DEPOSITO ' + STR(S.stoc_cantidad/S.stoc_stock_maximo * 100) + '%' END
	FROM STOCK S
	WHERE S.stoc_producto = @articulo and S.stoc_deposito = @deposito
	)
END

select stoc_producto,stoc_deposito,dbo.ej1(stoc_producto,stoc_deposito) from STOCK

