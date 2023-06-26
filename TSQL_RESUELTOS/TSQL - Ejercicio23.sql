/*23. Desarrolle el/los elementos de base de datos necesarios para que ante una venta
automaticamante se controle que en una misma factura no puedan venderse más
de dos productos con composición. Si esto ocurre debera rechazarse la factura.*/

CREATE TRIGGER dbo.Ejercicio23 ON item_factura FOR INSERT
AS
BEGIN
	DECLARE @tipo char(1)
	DECLARE @sucursal char(4)
	DECLARE @numero char(8)
	DECLARE @producto char(8)
	DECLARE cursor_ifact CURSOR FOR SELECT item_tipo,item_sucursal,item_numero,item_producto
									FROM inserted

	OPEN cursor_ifact
	FETCH NEXT FROM cursor_ifact
	INTO @tipo,@sucursal,@numero,@producto
	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF(
			SELECT COUNT(*)
			FROM inserted
			WHERE item_tipo+item_sucursal+item_numero = @tipo+@sucursal+@numero
				AND item_producto IN (
								SELECT comp_producto
								FROM Composicion
								)
			) >= 2
		BEGIN
		DELETE FROM Item_factura WHERE item_tipo+item_sucursal+item_numero = @tipo+@sucursal+@numero
		DELETE FROM Factura WHERE fact_tipo+fact_sucursal+fact_numero = @tipo+@sucursal+@numero
		RAISERROR('En una misma factura no pueden venderse mas de dos productos con composicion',1,1)
		ROLLBACK TRANSACTION
		END
	FETCH NEXT FROM cursor_ifact
	INTO @tipo,@sucursal,@numero,@producto
	CLOSE cursor_ifact
	DEALLOCATE cursor_ifact
END
CLOSE