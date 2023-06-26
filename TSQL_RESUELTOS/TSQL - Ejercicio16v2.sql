/*16. Desarrolle el/los elementos de base de datos necesarios para que ante una venta
automaticamante se descuenten del stock los articulos vendidos. Se descontaran
del deposito que mas producto poseea y se supone que el stock se almacena
tanto de productos simples como compuestos (si se acaba el stock de los
compuestos no se arman combos)
En caso que no alcance el stock de un deposito se descontara del siguiente y asi
hasta agotar los depositos posibles. En ultima instancia se dejara stock negativo
en el ultimo deposito que se desconto.*/


CREATE TRIGGER Ejercicio16 ON item_factura FOR INSERT
AS
BEGIN
	DECLARE @prod char(8), @cant decimal(12,2), @comp char(8), @cantComp decimal(12,2), @depo char(2)
	DECLARE cursor_update CURSOR FOR SELECT I.item_producto
											,SUM(I.item_cantidad - D.item_cantidad) 
									FROM inserted I join deleted D 
										on I.item_tipo+I.item_sucursal+I.item_numero = D.item_tipo+D.item_sucursal+D.item_numero
											AND I.item_producto = D.item_producto
									WHERE I.item_cantidad <> D.item_cantidad
									GROUP BY I.item_producto

	OPEN cursor_update
	FETCH NEXT FROM cursor_update 
	INTO @prod,@cant
	WHILE @@FETCH_STATUS = 0
		IF (dbo.EsProductoCompuesto(@prod)) = 1
			BEGIN
				DECLARE cursor_comp CURSOR FOR SELECT comp_componente,comp_cantidad
											FROM Composicion
											WHERE comp_producto = @prod
				OPEN cursor_comp
				FETCH NEXT FROM cursor_comp
				INTO @comp,@cantComp
				WHILE @@FETCH_STATUS = 0
				BEGIN 
					DECLARE @depo decimal(12,2)
					DECLARE @cantidadDepo decimal (12,2)
					DECLARE @cantidadADescontar decimal (12,2) = @cantComp * @cant
					DECLARE cursor_stock CURSOR FOR SELECT stoc_deposito,stoc_cantidad
													FROM STOCK
													WHERE stoc_producto = @prod
													ORDER BY stoc_cantidad DESC
					OPEN cursor_stock
					FETCH NEXT FROM cursor_stock
					INTO @depo,@cantidadDepo
					WHILE @cantidadADescontar <> 0 OR @@FETCH_STATUS = 0
					BEGIN
						IF @cantidadDepo >= @cantidadADescontar * @cant
						BEGIN
							UPDATE STOCK SET stoc_cantidad = stoc_cantidad - @cantidadADescontar
							WHERE stoc_deposito = @depo
							SET @cantidadADescontar = 0
						END
						IF @cantidadDepo < @cantidadADescontar
						BEGIN
							SET @cantidadADescontar -= @cantidadDepo
							UPDATE STOCK SET stoc_cantidad = 0
							WHERE stoc_deposito = @depo
						END
					FETCH NEXT FROM cursor_stock
					INTO @depo,@cantidadDepo
					END
					CLOSE cursor_stock
					DEALLOCATE cursor_stock
				FETCH NEXT FROM cursor_comp
				INTO @comp,@cantComp
				END
				CLOSE cursor_comp
				DEALLOCATE cursor_comp
			END
		ELSE
			BEGIN
				DECLARE @cantidadADescontarSimple decimal (12,2) = @cant
				DECLARE cursor_stock CURSOR FOR SELECT stoc_deposito,stoc_cantidad
												FROM STOCK
												WHERE stoc_producto = @prod
												ORDER BY stoc_cantidad DESC
				OPEN cursor_stock
				FETCH NEXT FROM cursor_stock
				INTO @depo,@cantidadDepo
				WHILE @cantidadADescontar <> 0 OR @@FETCH_STATUS = 0
				BEGIN
					IF @cantidadDepo >= @cant
					BEGIN
						UPDATE STOCK SET stoc_cantidad = stoc_cantidad - @cantidadADescontarSimple
						WHERE stoc_deposito = @depo
						SET @cantidadADescontarSimple = 0
					END
					IF @cantidadDepo < @cantidadADescontarSimple
					BEGIN
						SET @cantidadADescontarSimple -= @cantidadDepo
						UPDATE STOCK SET stoc_cantidad = 0
						WHERE stoc_deposito = @depo
					END
				FETCH NEXT FROM cursor_stock
				INTO @depo,@cantidadDepo
				END
				CLOSE cursor_stock
				DEALLOCATE cursor_stock

			END
END
GO
