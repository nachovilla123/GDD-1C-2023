/*18. Sabiendo que el limite de credito de un cliente es el monto maximo que se le
puede facturar mensualmente, cree el/los objetos de base de datos necesarios
para que dicha regla de negocio se cumpla automaticamente. No se conoce la
forma de acceso a los datos ni el procedimiento por el cual se emiten las facturas*/

CREATE TRIGGER dbo.ejercicio18 ON FACTURA FOR INSERT
AS
BEGIN
	DECLARE @tipo char(1)
			,@sucursal char(4)
			,@numero char(8)
			,@fecha SMALLDATETIME
			,@vendedor numeric(6,0)
			,@total decimal(12,2)
			,@cliente char(6)
	DECLARE cursor_inserted CURSOR FOR SELECT fact_tipo,fact_sucursal,fact_numero,fact_fecha,fact_vendedor,fact_total,fact_cliente
										FROM inserted
	OPEN cursor_inserted
	FETCH NEXT FROM cursor_inserted
	INTO @tipo,@sucursal,@numero,@fecha,@vendedor,@total,@cliente
	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF @total > (
						SELECT clie_limite_credito
						FROM Cliente
						WHERE clie_domicilio = @cliente
					)
		BEGIN
			PRINT 'Limite de credito superado para el cliente ' + STR(@cliente)
			ROLLBACK
		END
		ELSE IF @total < (
						SELECT clie_limite_credito
						FROM Cliente
						WHERE clie_domicilio = @cliente
					)
		BEGIN
			UPDATE Cliente SET clie_limite_credito -= @total
			 WHERE clie_codigo = @cliente
		END
	FETCH NEXT FROM cursor_inserted
	INTO @tipo,@sucursal,@numero,@fecha,@vendedor,@total,@cliente
	END
	CLOSE cursor_inserted
	DEALLOCATE cursor_inserted
END
CLOSE
		
	

SELECT * FROM Factura
select * from Cliente