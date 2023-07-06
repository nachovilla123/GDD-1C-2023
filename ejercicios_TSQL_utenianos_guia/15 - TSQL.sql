CREATE FUNCTION EJ15(@PRODUCTO char(8))
RETURNS decimal (12,2)
AS 
BEGIN 
	DECLARE @precio decimal (12,2)
	IF (@PRODUCTO IN (SELECT comp_producto FROM Composicion))
		SET @precio = (SELECT SUM(dbo.ej15(comp_componente)*comp_cantidad) FROM Composicion WHERE comp_producto = @PRODUCTO)
	ELSE
		SET @precio = (SELECT prod_precio FROM Producto WHERE @PRODUCTO = prod_codigo)
	RETURN @PRECIO
END

SELECT * from Composicion

select dbo.EJ15('00001104')