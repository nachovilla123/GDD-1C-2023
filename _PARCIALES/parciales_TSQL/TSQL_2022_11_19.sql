/*
1. Implementar una regla de negocio en línea donde nunca una factura
nueva tenga un precio de producto distinto al que figura en la tabla
PRODUCTO. Registrar en una estructura adicional todos los casos
donde se intenta guardar un precio distinto.
*/
/* TSQL */

-- nota de este parcial : 10 , sin comentarios

CREATE TABLE  Item_Factura_Precio_Erroneo (
		err_id int IDENTITY (1, 1) primary key, 
		err_tipo char(1), --fk
		err_sucursal char(4), -- fk
		err_factura char(8), -- fk 
		err_producto char(8),--fk
		err_precio_erroneo decimal(12,2)
		) ;
GO

ALTER TABLE Item_Factura_Precio_Erroneo
	ADD CONSTRAINT FK_Factura_precio_erroneo FOREIGN KEY(err_tipo,  err_sucursal, err_factura) REFERENCES Factura(fact_tipo, fact_sucursal, fact_numero ),
		FOREIGN KEY(err_producto) REFERENCES Producto(prod_codigo)
GO

CREATE  TRIGGER validate_precio on Item_Factura INSTEAD OF 
INSERT 
as 
DECLARE @producto char(8), @tipo char(1), @sucursal char(4), @factura_nro char(8), 
			@item_cantidad decimal(12,2), @precio decimal(12,2),
			@precio_tabla_producto decimal(12,2)

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
	
DECLARE cursor_precio_producto CURSOR FOR
		SELECT item_tipo, item_sucursal, item_numero, item_producto, item_cantidad, item_precio
		FROM INSERTED i
		
	OPEN cursor_precio_producto
	FETCH cursor_precio_producto INTO @tipo, @sucursal, @factura_nro, @producto, @item_cantidad, @precio
	
	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @precio_tabla_producto = (SELECT p.prod_precio FROM Producto p 
										WHERE p.prod_codigo = @producto) 
		IF @precio != @precio_tabla_producto
		BEGIN
			INSERT INTO item_factura_precio_erroneo ( err_tipo, err_sucursal, err_factura, err_producto, err_precio_erroneo)
				VALUES( @tipo, @sucursal, @factura_nro, @producto, @precio)
			

			INSERT INTO Item_Factura (item_tipo, item_sucursal, item_numero, item_producto, item_cantidad, item_precio)
				values(@tipo, @sucursal, @factura_nro, @producto, @item_cantidad, @precio_tabla_producto ) -- lo agrego con precio de tabla producto
		END
		ELSE 
		BEGIN 
			INSERT INTO Item_Factura (item_tipo, item_sucursal, item_numero, item_producto, item_cantidad, item_precio)
				values(@tipo, @sucursal, @factura_nro, @producto, @item_cantidad, @precio ) -- lo agrego con el precio que intentaron subirlo
		END
		
		UPDATE Factura SET fact_total = 
		(SELECT SUM(i.item_precio * i.item_cantidad   ) FROM Item_Factura i
			where i.item_tipo = @tipo AND
				i.item_numero = @factura_nro AND
				i.item_sucursal = @sucursal
			group by item_tipo, item_numero, item_sucursal 
		)
		where fact_tipo = @tipo AND
			fact_numero = @factura_nro AND
			fact_sucursal = @sucursal
		
		FETCH cursor_precio_producto INTO @tipo, @sucursal, @factura_nro, @producto, @item_cantidad, @precio

	END

	CLOSE cursor_precio_producto
	DEALLOCATE cursor_precio_producto


GO



