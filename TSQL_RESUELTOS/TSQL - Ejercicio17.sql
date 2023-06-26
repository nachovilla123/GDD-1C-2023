/*17. Sabiendo que el punto de reposicion del stock es la menor cantidad de ese objeto
que se debe almacenar en el deposito y que el stock maximo es la maxima
cantidad de ese producto en ese deposito, cree el/los objetos de base de datos
necesarios para que dicha regla de negocio se cumpla automaticamente. No se
conoce la forma de acceso a los datos ni el procedimiento por el cual se
incrementa o descuenta stock*/


CREATE TRIGGER dbo.ejercicio17 ON STOCK	FOR INSERT,UPDATE
AS
BEGIN
	DECLARE @producto CHAR(8),
			@deposito CHAR(8),
			@cantidad DECIMAL (12,2),
			@minimo DECIMAL (12,2),
			@maximo DECIMAL (12,2)

	DECLARE cursor_inserted CURSOR FOR SELECT stoc_cantidad,stoc_punto_reposicion,stoc_stock_maximo,stoc_producto,stoc_deposito
										FROM inserted
	OPEN cursor_inserted
	FETCH NEXT FROM cursor_inserted
	INTO @cantidad,@minimo,@maximo,@producto,@deposito
	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF @cantidad > @maximo
			BEGIN
				PRINT 'Se está excediendo la cantidad maxima del producto ' + @producto + ' en el deposito ' + @deposito + ' por ' + STR(@cantidad - @maximo) + ' unidades. No se puede realizar la operacion'
				ROLLBACK
			END

		ELSE IF @cantidad < @minimo
			BEGIN
				PRINT 'El producto ' + @producto + ' en el deposito ' + @deposito + ' se encuentra por debajo del minimo. Reponer!'
			END
	FETCH NEXT FROM cursor_inserted
	INTO @cantidad,@minimo,@maximo,@producto,@deposito
	END
	CLOSE cursor_inserted
	DEALLOCATE cursor_inserted
END
GO