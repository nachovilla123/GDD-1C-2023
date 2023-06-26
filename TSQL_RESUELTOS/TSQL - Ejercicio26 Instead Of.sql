/*26. Desarrolle el/los elementos de base de datos necesarios para que se cumpla
automaticamente la regla de que una factura no puede contener productos que
sean componentes de otros productos. En caso de que esto ocurra no debe
grabarse esa factura y debe emitirse un error en pantalla.*/

CREATE TRIGGER dbo.ejercicio26 ON item_factura INSTEAD OF Insert
AS
BEGIN
	DECLARE @tipo char(1)
	DECLARE @sucursal char(4)
	DECLARE @numero char(8)
	DECLARE @producto char(8)
	DECLARE @cantidad decimal(12,2)
	DECLARE @precio decimal(12,2)

	DECLARE cursor_ifact CURSOR FOR SELECT *
									FROM inserted

	OPEN cursor_ifact
	FETCH NEXT FROM cursor_ifact
	INTO @tipo,@sucursal,@numero,@producto,@cantidad,@precio
	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF EXISTS(SELECT *
				  FROM Composicion
				  WHERE comp_componente = @producto)
		BEGIN
			DELETE FROM Factura WHERE fact_tipo+fact_sucursal+fact_numero = @tipo+@sucursal+@numero
			DELETE FROM Item_Factura WHERE item_tipo+item_sucursal+item_numero = @tipo+@sucursal+@numero
			RAISERROR('EL producto a insertar es componente de otro producto, no se puede insertar en la factura',1,1)
			ROLLBACK TRANSACTION
		END
		ELSE
		BEGIN
			INSERT INTO Item_Factura
			VALUES (@tipo,@sucursal,@numero,@producto,@cantidad,@precio)
		END
	FETCH NEXT FROM cursor_ifact
	INTO @tipo,@sucursal,@numero,@producto,@cantidad,@precio
	END
	CLOSE cursor_ifact
	DEALLOCATE cursor_ifact
END
GO