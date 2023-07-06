/*14. Agregar el/los objetos necesarios para que si un cliente compra un producto
compuesto a un precio menor que la suma de los precios de sus componentes
que imprima la fecha, que cliente, que productos y a qué precio se realizó la
compra. No se deberá permitir que dicho precio sea menor a la mitad de la suma
de los componentes.*/


CREATE FUNCTION dbo.EsProductoCompuesto(@producto char(8))
RETURNS BIT
AS
BEGIN
	DECLARE @esProductoCompuesto BIT = 0
	IF EXISTS (SELECT * FROM Composicion WHERE comp_producto = @producto)
		BEGIN
			SET @esProductoCompuesto = 1
		END
	RETURN @esProductoCompuesto
END

ALTER FUNCTION dbo.precioCompuesto (@producto char(8))
RETURNS decimal(12,2)
AS
BEGIN
	DECLARE @precioCompuesto decimal(12,2) = 0
	DECLARE @componenteCompuesto char(8)
	DECLARE @cantidad decimal(12,2)

	IF dbo.EsProductoCompuesto(@producto) = 1
		DECLARE cursor_compuesto CURSOR FOR SELECT comp_componente, comp_cantidad
											FROM Composicion
											WHERE comp_producto = @producto
		OPEN cursor_compuesto
		FETCH NEXT FROM cursor_compuesto
		INTO @componenteCompuesto,@cantidad
		WHILE @@FETCH_STATUS = 0
			BEGIN
				SET @precioCompuesto = @precioCompuesto + @cantidad * (
																		SELECT prod_precio
																		FROM Producto
																		WHERE prod_codigo = @componenteCompuesto)
				FETCH NEXT FROM cursor_compuesto
				INTO @componenteCompuesto,@cantidad
			END
		CLOSE cursor_compuesto
		DEALLOCATE cursor_compuesto
		RETURN @precioCompuesto

END
GO

/*14. Agregar el/los objetos necesarios para que si un cliente compra un producto
compuesto a un precio menor que la suma de los precios de sus componentes
que imprima la fecha, que cliente, que productos y a qué precio se realizó la
compra. No se deberá permitir que dicho precio sea menor a la mitad de la suma
de los componentes.*/

CREATE TRIGGER dbo.ejercicio14 ON item_factura INSTEAD OF INSERT
AS
BEGIN
	declare @tipo char(1)
	declare @sucursal char(4)
	declare @numero char(8)
	declare @prodAInsertar char(8)
	declare @precio decimal(12,2)
	declare @fecha SMALLDATETIME
	declare @cliente char(6)
	
	DECLARE cursor_compra CURSOR FOR SELECT item_tipo,item_sucursal,item_numero,item_producto,item_precio
									FROM inserted
	OPEN cursor_compra
	FETCH NEXT FROM cursor_compra
	INTO @tipo,@sucursal,@numero,@prodAInsertar,@precio
	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @cliente = (
						SELECT fact_cliente
						FROM Factura
						WHERE fact_tipo+fact_sucursal+fact_numero = @tipo+@sucursal+@numero
						)
		SET @fecha = (
						SELECT fact_fecha
						FROM Factura
						WHERE fact_tipo+fact_sucursal+fact_numero = @tipo+@sucursal+@numero
						)
		IF dbo.EsProductoCompuesto(@prodAInsertar) = 1
			BEGIN
				IF @precio > dbo.precioCompuesto(@prodAInsertar)/2
				BEGIN
					INSERT INTO Item_Factura
						SELECT *
						FROM inserted
						where item_producto = @prodAInsertar
					
					PRINT @fecha
					PRINT @cliente
				END
			ELSE
				PRINT 'El precio producto no puede ser menor a la mitad de la suma de sus productos compuestos'
			END
		FETCH NEXT FROM cursor_compra
		INTO @tipo,@sucursal,@numero,@prodAInsertar,@precio
		END
	END
	GO