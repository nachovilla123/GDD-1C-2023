/*9. Crear el/los objetos de base de datos que ante alguna modificación de un ítem de
factura de un artículo con composición realice el movimiento de sus
correspondientes componentes.*/

ALTER TRIGGER Ejercicio9v2 ON item_factura FOR UPDATE
AS
BEGIN
	DECLARE @prod char(8), @cant decimal(12,2), @comp char(8), @cantComp decimal(12,2), @depo char(2)
	DECLARE cursor_update CURSOR FOR SELECT I.item_producto
											,SUM(I.item_cantidad - D.item_cantidad) 
									FROM inserted I join deleted D 
										on I.item_tipo+I.item_sucursal+I.item_numero = D.item_tipo+D.item_sucursal+D.item_numero
											AND I.item_producto = D.item_producto, Composicion C
									WHERE I.item_cantidad <> D.item_cantidad AND I.item_producto = C.comp_producto
									GROUP BY I.item_producto
	OPEN cursor_update
	FETCH NEXT FROM cursor_update 
	INTO @prod,@cant
	WHILE @@FETCH_STATUS = 0
	BEGIN
		DECLARE cursor_comp CURSOR FOR SELECT comp_componente,comp_cantidad
										FROM Composicion
										WHERE comp_producto = @prod
		OPEN cursor_comp
		FETCH NEXT FROM cursor_comp
		INTO @comp,@cantComp
		WHILE @@FETCH_STATUS = 0
		BEGIN 
			SET @depo = (
							SELECT TOP 1 stoc_deposito
							FROM STOCK
							WHERE stoc_producto = @comp
								AND stoc_cantidad > @cant*@cantComp
							) 
			UPDATE STOCK SET stoc_cantidad = stoc_cantidad - @cant*@cantComp
				WHERE stoc_deposito = @depo
			FETCH NEXT FROM cursor_comp
			INTO @comp,@cantComp
			END
			CLOSE cursor_comp
			DEALLOCATE cursor_comp
	FETCH NEXT FROM cursor_update 
	INTO @prod,@cant
	END
	CLOSE cursor_update
	DEALLOCATE cursor_update
END
GO




/*
SELECT *
FROM Item_Factura,Composicion
WHERE item_producto = comp_producto*/

select * from Item_Factura