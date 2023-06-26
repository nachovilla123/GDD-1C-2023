/*15. Cree el/los objetos de base de datos necesarios para que el objeto principal
reciba un producto como parametro y retorne el precio del mismo.
Se debe prever que el precio de los productos compuestos sera la sumatoria de
los componentes del mismo multiplicado por sus respectivas cantidades. No se
conocen los nivles de anidamiento posibles de los productos. Se asegura que
nunca un producto esta compuesto por si mismo a ningun nivel. El objeto
principal debe poder ser utilizado como filtro en el where de una sentencia
select.*/

ALTER FUNCTION dbo.precioCompuesto3 (@producto char(8))
RETURNS decimal(12,2)
AS
BEGIN
	DECLARE @precioProd decimal(12,2) = 0
	DECLARE @prodCompuesto char(8)
	DECLARE @cantProdCompuesto decimal(12,2)
	IF NOT EXISTS(SELECT * FROM Composicion WHERE comp_producto = @producto)
	BEGIN
		SET @precioProd = (
							SELECT prod_precio
							FROM Producto
							WHERE prod_codigo = @producto
							)
		RETURN @precioProd
	END
	ELSE
	BEGIN
		DECLARE cursor_prod CURSOR FOR SELECT comp_componente,comp_cantidad
										FROM Composicion
										WHERE comp_producto = @producto
		OPEN cursor_prod
		FETCH NEXT FROM cursor_prod
		INTO @prodCompuesto,@cantProdCompuesto
		WHILE @@FETCH_STATUS = 0
		BEGIN
			SET @precioProd = @precioProd + dbo.precioCompuesto3(@prodCompuesto) * @cantProdCompuesto
		FETCH NEXT FROM cursor_prod
		INTO @prodCompuesto,@cantProdCompuesto
		END
		CLOSE cursor_prod
		DEALLOCATE cursor_prod
		--RETURN @precioProd
	END
	RETURN @precioProd
END
GO

select * from Composicion

select dbo.ejercicio15('00001104')

select * from Producto
where prod_codigo = '00001718'