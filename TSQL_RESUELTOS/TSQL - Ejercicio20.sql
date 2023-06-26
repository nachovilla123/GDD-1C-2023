/*20. Crear el/los objeto/s necesarios para mantener actualizadas las comisiones del
vendedor.
El cálculo de la comisión está dado por el 5% de la venta total efectuada por ese
vendedor en ese mes, más un 3% adicional en caso de que ese vendedor haya
vendido por lo menos 50 productos distintos en el mes.*/

SELECT * from Empleado


CREATE TRIGGER dbo.Ejercicio21 ON Factura FOR INSERT
AS
BEGIN
	DECLARE @fecha smalldatetime
			,@vendedor numeric(6,0)
	DECLARE @comision decimal (12,2)
	DECLARE cursor_fact CURSOR FOR SELECT fact_fecha,fact_vendedor
									FROM inserted
	OPEN cursor_fact
	FETCH NEXT FROM cursor_fact
	INTO @fecha,@vendedor
	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @comision = (
							SELECT SUM(item_precio*item_cantidad)*(0.05 +
																			CASE WHEN COUNT(DISTINCT item_producto) > 50 THEN 0.03
																				ELSE 0
																				END
																				)
							FROM Factura
								INNER JOIN Item_Factura
									ON item_tipo = fact_tipo AND item_sucursal = fact_sucursal AND item_numero = fact_numero
							WHERE fact_vendedor = @vendedor
								AND YEAR(fact_fecha) = YEAR(@fecha)
								AND MONTH(fact_fecha) = MONTH(@fecha)
							)
		UPDATE Empleado SET empl_comision = @comision WHERE empl_codigo = @vendedor
		FETCH NEXT FROM cursor_fact
		INTO @fecha,@vendedor
	END
	CLOSE cursor_fact
	DEALLOCATE cursor_fact
END
GO
