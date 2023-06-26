/*21. Desarrolle el/los elementos de base de datos necesarios para que se cumpla
automaticamente la regla de que en una factura no puede contener productos de
diferentes familias. En caso de que esto ocurra no debe grabarse esa factura y
debe emitirse un error en pantalla.*/

CREATE TRIGGER dbo.ejercicio21 ON Item_factura FOR INSERT
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
		declare @familiaProd char(3) = (
									SELECT prod_familia
									FROM Producto
									WHERE prod_codigo = @producto
									)
		IF EXISTS(
					SELECT *
					FROM Item_Factura
						INNER JOIN Producto
							ON prod_codigo = item_producto		
					WHERE item_tipo+item_sucursal+item_numero = @tipo+@sucursal+@numero
						AND prod_familia = @familiaProd
						AND prod_codigo <> @producto
						)
		BEGIN
			DELETE FROM Item_factura WHERE item_tipo+item_sucursal+item_numero = @tipo+@sucursal+@numero
			DELETE FROM Factura WHERE fact_tipo+fact_sucursal+fact_numero = @tipo+@sucursal+@numero
			RAISERROR('La familia del producto a insertar ya existe en la factura mencionada',1,1)
			ROLLBACK TRANSACTION
		END
	FETCH NEXT FROM cursor_ifact
	INTO @tipo,@sucursal,@numero,@producto
	END
	CLOSE cursor_ifact
	DEALLOCATE cursor_ifact
END
GO
