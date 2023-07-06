/*2. Realizar una función que dado un artículo y una fecha, retorne el stock que
existía a esa fecha*/

CREATE FUNCTION Ejercicio2 (@art varchar(8),@date datetime)

RETURNS decimal(12,2)

AS
BEGIN
RETURN
	(
		SELECT SUM(stoc_cantidad)
		FROM STOCK S
		WHERE S.stoc_producto = @art
	)
	+
	(
		SELECT SUM(item_cantidad)
		FROM Item_Factura IFACT
			INNER JOIN Factura F
				ON F.fact_tipo = IFACT.item_tipo AND F.fact_sucursal = IFACT.item_sucursal AND F.fact_numero = IFACT.item_numero
		WHERE IFACT.item_producto = @art AND F.fact_fecha <= @date
	) 
END
GO