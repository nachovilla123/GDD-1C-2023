/*28. Se requiere reasignar los vendedores a los clientes. Para ello se solicita que
realice el o los objetos de base de datos necesarios para asignar a cada uno de los
clientes el vendedor que le corresponda, entendiendo que el vendedor que le
corresponde es aquel que le vendió más facturas a ese cliente, si en particular un
cliente no tiene facturas compradas se le deberá asignar el vendedor con más
venta de la empresa, o sea, el que en monto haya vendido más.*/

CREATE PROC dbo.ejercicio28
AS
BEGIN
	CREATE @clieCodigo char(5)
	CREATE @clieVendedor numeric(6,0)
	CREATE cursor_cliente CURSOR FOR SELECT clie_codigo
									 FROM Cliente
	OPEN cursor_cliente
	FETCH NEXT FROM cursor_cliente
	INTO @clieCodigo
	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF EXISTS(
					SELECT *
					FROM Factura
					WHERE fact_cliente = @clieCodigo
					)
		BEGIN
		SET @clieVendedor = (
								SELECT TOP 1 fact_vendedor
								FROM Factura
								WHERE fact_cliente = @clieCodigo
								GROUP BY fact_cliente,fact_vendedor
								ORDER BY COUNT(fact_vendedor) DESC
								)
		UPDATE Cliente SET clie_vendedor = @clieVendedor WHERE clie_codigo = @clieCodigo
		END
		ELSE
		BEGIN
		SET @clieVendedor = 
							(
								SELECT TOP 1 fact_vendedor
								FROM Factura
								GROUP BY fact_vendedor
								ORDER BY COUNT(*) DESC
								)
		UPDATE Cliente SET clie_vendedor = @clieVendedor WHERE clie_codigo = @clieCodigo
		END
	FETCH NEXT FROM cursor_cliente
	INTO @clieCodigo
	END
	CLOSE cursor_cliente
	DEALLOCATE cursor_cliente
END
GO