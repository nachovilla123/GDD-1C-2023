/*8. Realizar un procedimiento que complete la tabla Diferencias de precios, para los
productos facturados que tengan composición y en los cuales el precio de
facturación sea diferente al precio del cálculo de los precios unitarios por
cantidad de sus componentes, se aclara que un producto que compone a otro,
también puede estar compuesto por otros y así sucesivamente, la tabla se debe
crear y está formada por las siguientes columnas:

DIFERENCIAS
	█ Código : Código del articulo
	█ Detalle :Detalle del articulo
	█ Cantidad : Cantidad de productos que conforman el combo
	█ Precio_generado : Precio que se compone a través de sus componentes
	█ Precio_facturado : Precio del producto
*/

--CREATE TABLE Diferencias
--(
--	dif_codigo char(8) NULL,
--	dif_detalle char(50) NULL,
--	dif_cantidad int NULL,
--	dif_precio_generado decimal(12,2) NULL,
--	dif_precio_facturado decimal(12,2) NULL
--)

CREATE PROCEDURE EJ8

AS	
	BEGIN
	
	DECLARE @codigo char(8) ,@detalle char(50),@cantidad int,@precio_generado decimal(12,2) ,@precio_facturado decimal(12,2) 


	DECLARE cursor_diferencia CURSOR
		FOR SELECT 
				P.prod_codigo,
				P.prod_detalle,
				(
					SELECT COUNT(DISTINCT C1.comp_componente)
					FROM Composicion C1
					WHERE C1.comp_producto = P.prod_codigo
				),
				(
					SELECT SUM(C2.comp_cantidad * P2.prod_precio)
					FROM Composicion C2
						INNER JOIN Producto P2 on C2.comp_componente = P2.prod_codigo
					WHERE C2.comp_producto = P.prod_codigo
				),
				Sum(IT.item_precio)
			
			FROM Producto P
				JOIN Item_Factura IT 
					ON IT.item_producto = P.prod_codigo
			WHERE IT.item_producto IN (
										SELECT C.comp_producto 
										FROM Composicion C
									  )
			GROUP BY P.prod_codigo,P.prod_detalle,IT.item_producto
			HAVING SUM(IT.item_producto * IT.item_cantidad) <> (
																		SELECT SUM(PH.prod_precio * CH.comp_cantidad)
																		FROM Producto PH
																			INNER JOIN Composicion CH
																				ON CH.comp_componente = PH.prod_codigo
																		WHERE CH.comp_producto = IT.item_producto
																	 )


			OPEN cursor_diferencia
			FETCH NEXT FROM cursor_diferencia
				INTO @codigo,@detalle,@cantidad,@precio_generado,@precio_facturado

			WHILE(@@FETCH_STATUS = 0)
				BEGIN
					INSERT INTO Diferencias
						VALUES(@codigo,@detalle,@cantidad,@precio_generado,@precio_facturado)
					FETCH NEXT FROM cursor_diferencia
						INTO @codigo,@detalle,@cantidad,@precio_generado,@precio_facturado
				END
			CLOSE cursor_diferencia
			DEALLOCATE cursor_diferencia
				
	 END
GO



EXEC DBO.EJ8
select * from diferencias

