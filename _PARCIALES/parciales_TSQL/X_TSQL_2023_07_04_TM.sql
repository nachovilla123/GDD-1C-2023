/*
2. Actualmente el campo fact_vendedor representa al empleado que vendió
la factura. Implementar el/los objetos necesarios para respetar la
integridad referenciales de dicho campo suponiendo que no existe una
foreign key entre ambos.

NOTA: No se puede usar una foreign key para el ejercicio, deberá buscar
otro método
*/

-- nota de mi resolucion: unicamente checkea nuevas facturas y editadas. no se contemplan las facturas que estan en el sistema actualmente.

ALTER TRIGGER vendedores
ON FACTURA
AFTER INSERT,UPDATE
AS
BEGIN
	SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
	DECLARE @id_vendedor NUMERIC(6,0)

	DECLARE facturas_insertadas CURSOR FOR
		SELECT fact_vendedor FROM inserted

	OPEN facturas_insertadas
	FETCH NEXT FROM facturas_insertadas INTO @id_vendedor
	
		WHILE(@@FETCH_STATUS = 0)
		BEGIN
			IF NOT EXISTS (SELECT * FROM Empleado E WHERE E.empl_codigo = @id_vendedor)	-- SI 1 FACTURA NO CUMPLE SE CANCELA LA TRANSACCION
				BEGIN
					ROLLBACK TRANSACTION
				END
			FETCH NEXT FROM facturas_insertadas INTO @id_vendedor
		END
	CLOSE facturas_insertadas
	DEALLOCATE facturas_insertadas

END


INSERT INTO Factura (fact_tipo,fact_sucursal,fact_numero,fact_fecha,fact_vendedor,fact_total,fact_total_impuestos,fact_cliente)
	VALUES ('A','003','0006489','2010-01-23 00:00:00',NULL,'105.73','18.33','01634') 

SELECT * FROM Factura
