/*9. Crear el/los objetos de base de datos que ante alguna modificación de un ítem de
factura de un artículo con composición realice el movimiento de sus
correspondientes componentes.*/

DROP TRIGGER Ejercicio9

ALTER TRIGGER Ejercicio9 ON item_factura FOR INSERT
AS
IF (SELECT COUNT(*)
	FROM inserted I
	WHERE I.item_producto IN (
								SELECT comp_producto
								FROM Composicion
							)
	) > 0
	BEGIN
		DECLARE @Codigo char(8), @Cantidad INT, @Deposito char(2)
		DECLARE cursor_insert CURSOR
			FOR SELECT S.stoc_producto
					,S.stoc_cantidad
					,S.stoc_deposito
				FROM STOCK S
					INNER JOIN Composicion C
						ON C.comp_componente = S.stoc_producto
				WHERE S.stoc_producto IN (SELECT Comp_componente
										FROM Composicion
										INNER JOIN inserted
											ON item_producto = comp_producto
											)
					AND S.stoc_deposito = (
											SELECT RIGHT(item_sucursal,2)
											FROM inserted
											WHERE C.comp_producto = item_producto
											)

				GROUP BY S.stoc_producto,S.stoc_cantidad,S.stoc_deposito

		OPEN cursor_insert
		FETCH NEXT FROM cursor_insert
		INTO @Codigo,@cantidad,@Deposito
		WHILE @@FETCH_STATUS = 0
		BEGIN
			UPDATE STOCK 
				SET stoc_cantidad = stoc_cantidad - @cantidad
				WHERE stoc_producto = @Codigo AND stoc_deposito = @Deposito
				FETCH NEXT FROM cursor_insert
				INTO @Codigo,@cantidad,@Deposito
		END
		CLOSE cursor_insert
		DEALLOCATE cursor_insert

	END
GO




/*
select * from Item_Factura
where item_producto IN (SELECT comp_producto
						FROM Composicion)

SELECT * from stock
where stoc_producto IN (SELECT comp_producto
						FROM Composicion)
						*/