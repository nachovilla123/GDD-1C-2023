CREATE TRIGGER ej21 ON FACTURA FOR INSERT

AS

BEGIN
       IF exists(SELECT fact_numero+fact_sucursal+fact_tipo 
				 FROM inserted 
					INNER JOIN Item_Factura
						ON item_numero+item_sucursal+item_tipo = fact_numero+fact_sucursal+fact_tipo
					INNER JOIN Producto 
						ON prod_codigo = item_producto JOIN Familia ON fami_id = prod_familia
                     GROUP BY fact_numero+fact_sucursal+fact_tipo
                     HAVING COUNT(distinct fami_id) <> 1 )
              BEGIN
              DECLARE @NUMERO char(8),@SUCURSAL char(4),@TIPO char(1)
              DECLARE cursorFacturas CURSOR FOR SELECT fact_numero,fact_sucursal,fact_tipo FROM inserted
              OPEN cursorFacturas
              FETCH NEXT FROM cursorFacturas INTO @NUMERO,@SUCURSAL,@TIPO
              WHILE @@FETCH_STATUS = 0
              BEGIN
                     DELETE FROM Item_Factura WHERE item_numero+item_sucursal+item_tipo = @NUMERO+@SUCURSAL+@TIPO
                     DELETE FROM Factura WHERE fact_numero+fact_sucursal+fact_tipo = @NUMERO+@SUCURSAL+@TIPO
                     FETCH NEXT FROM cursorFacturas INTO @NUMERO,@SUCURSAL,@TIPO
              END
              CLOSE cursorFacturas
              DEALLOCATE cursorFacturas
              RAISERROR ('no puede ingresar productos de mas de una familia en una misma factura.',1,1)
              ROLLBACK
       END
END