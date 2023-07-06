/*30. Agregar el/los objetos necesarios para crear una regla por la cual un cliente no
pueda comprar más de 100 unidades en el mes de ningún producto, si esto
ocurre no se deberá ingresar la operación y se deberá emitir un mensaje “Se ha
superado el límite máximo de compra de un producto”. Se sabe que esta regla se
cumple y que las facturas no pueden ser modificadas.*/

CREATE TRIGGER dbo.Ejercicio30 ON item_factura FOR INSERT
AS
BEGIN
	DECLARE @tipo char(1)
	DECLARE @sucursal char(4)
	DECLARE @numero char(8)
	DECLARE @producto char(8)
	DECLARE @cantProducto decimal(12,2)
	DECLARE @itemsVendidosEnELMes int
	DECLARE @excedente int
	DECLARE cursor_ifact CURSOR FOR SELECT item_tipo,item_sucursal,item_numero,item_cantidad
									FROM inserted
	OPEN cursor_ifact
	FETCH NEXT FROM cursor_ifact
	INTO @tipo,@sucursal,@numero,@cantProducto
	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @itemsVendidosEnELMes = (
								SELECT sum(item_cantidad)
								FROM Item_Factura
									INNER JOIN Factura
										ON fact_tipo+fact_sucursal+fact_numero = @tipo+@sucursal+@numero
								WHERE item_producto = @producto
									AND fact_fecha = (SELECT MONTH(GETDATE()))
								)
		IF (@itemsVendidosEnELMes + @cantProducto) > 100
		BEGIN
			SET @excedente = (@itemsVendidosEnELMes + @cantProducto)-100
			DELETE FROM Item_Factura WHERE item_tipo+item_sucursal+item_numero = @tipo+@sucursal+@numero
			DELETE FROM Factura WHERE fact_tipo+fact_sucursal+fact_numero = @tipo+@sucursal+@numero
			RAISERROR('No se puede comprar mas del producto %s, se superaron las unidades por %i',1,1,@producto,@excedente)
			ROLLBACK TRANSACTION
		END
		FETCH NEXT FROM cursor_ifact
		INTO @tipo,@sucursal,@numero,@cantProducto
	END
	CLOSE cursor_ifact
	DEALLOCATE cursor_ifact
END
CLOSE

--Esta bien que borre la factura entera si un renglon no se puede ingresar?