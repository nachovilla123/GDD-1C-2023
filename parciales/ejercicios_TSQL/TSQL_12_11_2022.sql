/*
2. Implementar una regla de negocio de validación en línea que permita
validar el STOCK al realizarse una venta. Cada venta se debe
descontar sobre el depósito 00. En caso de que se venda un producto
compuesto, el descuento de stock se debe realizar por sus
componentes. Si no hay STOCK para ese artículo, no se deberá
guardar ese artículo, pero si los otros en los cuales hay stock positivo.
Es decir, solamente se deberán guardar aquellos para los cuales si hay
stock, sin guardarse los que no poseen cantidades suficientes.
*/

GO
CREATE TRIGGER ej_nacho_par 
	ON ITEM_FACTURA
	INSTEAD OF INSERT
AS
BEGIN
	
	DECLARE @producto_codigo char(8) = (SELECT I.item_producto FROM inserted I)
	DECLARE @producto_cantidad DECIMAL (12,2) = (SELECT I.item_cantidad FROM inserted I)
	
	IF EXISTS (SELECT * FROM Composicion C where C.comp_producto = @producto_codigo)
		BEGIN
			DECLARE @componente CHAR(8), @cantidad DECIMAL(12,2)
			
			DECLARE cursor_componentes CURSOR FOR
				SELECT C.comp_componente,C.comp_cantidad FROM Composicion C Where C.comp_producto = @producto_codigo		-- NO CONTEMPLO QUE TENGA 2 COMPONENTES REPETIDOS (2 FILAS DISTINTAS)
			
			OPEN cursor_componentes
				FETCH NEXT FROM cursor_componentes INTO @componente, @cantidad
			
				WHILE(@@FETCH_STATUS = 0)
					BEGIN

						IF (@cantidad <= (
										SELECT S.stoc_cantidad 
										FROM STOCK S 
										WHERE S.stoc_deposito = '00' AND S.stoc_producto = @componente
										)
							)
							BEGIN
								UPDATE STOCK SET stoc_cantidad = stoc_cantidad - @cantidad  WHERE stoc_producto = @componente
									SELECT S.stoc_cantidad FROM STOCK S WHERE S.stoc_deposito = '00'
								INSERT INTO Item_Factura (item_tipo,item_sucursal,item_numero,item_producto,item_cantidad,item_precio)  
										SELECT * FROM inserted 
							END

						FETCH NEXT FROM cursor_componentes INTO @componente, @cantidad

					END

			CLOSE cursor_componentes
			DEALLOCATE cursor_componentes
			--DESCONTAR DE LOS COMPONENTES
		END
	ELSE 
		BEGIN		--DESCONTAR PRODUCTO SIMPLE
			IF 
			 (@producto_cantidad <=
				(SELECT S.stoc_cantidad 
										FROM STOCK S 
										WHERE S.stoc_deposito = '00' AND S.stoc_producto = @producto_codigo 
			))
				BEGIN
					UPDATE STOCK SET stoc_cantidad = stoc_cantidad - @producto_cantidad  WHERE stoc_producto = @producto_codigo

					INSERT INTO Item_Factura (item_tipo,item_sucursal,item_numero,item_producto,item_cantidad,item_precio)  
						SELECT * FROM inserted 
				END
			ELSE
				BEGIN	
					ROLLBACK
					print 'rompio'
					RETURN
				END 
		END 
END


SELECT s.stoc_producto,S.stoc_cantidad FROM STOCK S WHERE S.stoc_deposito = '00'
UPDATE STOCK SET stoc_cantidad = stoc_cantidad + 50  WHERE stoc_producto = '00001109'
SELECT S.stoc_cantidad FROM STOCK S WHERE S.stoc_deposito = '00'


SELECT * FROM STOCK S WHERE S.stoc_deposito = '00' and s.stoc_producto = '00001109'
INSERT INTO STOCK(stoc_producto,stoc_deposito,stoc_cantidad) VALUES ('00001109','00','50')


DELETE FROM Item_Factura WHERE item_producto = '00001109'
INSERT INTO Item_Factura (item_tipo,item_sucursal,item_numero,item_producto,item_cantidad,item_precio) VALUES ('@','43!$','5dvd15ss','00001109','5','5')

SELECT * FROM Item_Factura WHERE item_producto = '00001109'


SELECT * FROM Item_Factura IT WHERE IT.item_cantidad > 0 AND IT.item_producto = '2' ORDER BY IT.item_cantidad ASC