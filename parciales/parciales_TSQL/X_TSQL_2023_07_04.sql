/*2. Se requiere realizar una verificación de los precios de los COMBOS, para
ello se solicita que cree el o los objetos necesarios para realizar una
operación que actualice que el precio de un producto compuesto
(COMBO) es el 90% de la suma de los precios de sus componentes por
las cantidades que los componen. Se debe considerar que un producto
compuesto puede estar compuesto por otros productos compuestos.*/

/*
2. Se requiere realizar una verificación de los precios de los COMBOS, 

para ello se solicita que cree el o los objetos necesarios para realizar una operación 
que 

actualice que el precio de un producto compuesto (COMBO)
es el 90% de la suma de los precios de sus componentes por las cantidades que los componen. 

Se debe considerar que un producto compuesto puede estar compuesto por otros productos compuestos.
*/

/*
	Pensamientos para encararlo:
	-Una funcion que me devuelve la sumatoria del precio de los componentes de un producto compuesto
		Para eso esa funcion deberia fijarse si ese producto compuesto tiene un producto compuesto dentro de si mismo.

	- Un proccedure que le pasamos el codigo de un producto compuesto y le actualiza el precio utilizando la funcion
		que hicimos anteriormente
*/






/*
Se requiere realizar una verificación de los precios de los COMBOS, 

para ello se solicita que cree el o los objetos necesarios para realizar una operación que actualice que 

el precio de un producto compuesto (COMBO) es el 90% de la suma de los precios de sus componentes por las cantidades que los componen. 

Se debe considerar que un producto compuesto puede estar compuesto por otros productos compuestos.
*/


ALTER FUNCTION sumatoria_precio_componentes(@codigo_producto CHAR(8))
RETURNS INT
AS
BEGIN
	DECLARE @componente CHAR(8), @precio_final DECIMAL(12,2) = 0 ,@cantidad_componente INT ,@precio_componente DECIMAL(12,2)
	
	if exists( SELECT * FROM Composicion C where C.comp_producto = @codigo_producto )
		begin
			DECLARE el_cursor CURSOR FOR 
				SELECT 
				C.comp_componente, P.prod_precio,C.comp_cantidad
				FROM Composicion C
					INNER JOIN Producto P ON
						P.prod_codigo = C.comp_componente
				WHERE C.comp_producto = @codigo_producto
	 
			OPEN el_cursor
			FETCH NEXT FROM el_cursor INTO  @componente, @precio_componente,@cantidad_componente
			WHILE(@@FETCH_STATUS = 0)
				BEGIN
					IF NOT EXISTS(SELECT * FROM Composicion C1 WHERE C1.comp_producto = @componente)
						BEGIN
							SET @precio_final = @precio_final + @precio_componente*@cantidad_componente
						END
					ELSE
						BEGIN
							SET @precio_final = @precio_final + dbo.sumatoria_precio_componentes(@componente) * @cantidad_componente
						END
					FETCH NEXT FROM el_cursor INTO  @componente, @precio_componente,@cantidad_componente
				END

			CLOSE el_cursor
			DEALLOCATE el_cursor
		end

	RETURN @precio_final
END


GO
ALTER PROCEDURE verificar_cumplimiento_combos	-- SE DEBE EJECUTAR A MANO 1 VEZ PARA PONER AL DIA LA VERIFICACIÒN
as
BEGIN
	declare @comp_producto char(8)		

		DECLARE cd_cursor CURSOR FOR
		SELECT 
			C.comp_producto
		FROM Producto P
			INNER JOIN Composicion C
				ON P.prod_codigo = C.comp_producto 
	
	OPEN cd_cursor
		FETCH NEXT FROM cd_cursor INTO @comp_producto
		while(@@FETCH_STATUS = 0)
			begin
				--acciones
				UPDATE Producto
				SET prod_precio = dbo.sumatoria_precio_componentes(@comp_producto) * 0.9
				WHERE prod_codigo = @comp_producto;

				FETCH NEXT FROM cd_cursor INTO @comp_producto
			end
	CLOSE cd_cursor
	DEALLOCATE cd_cursor
END


GO
alter TRIGGER trigerActualizadorProductos ON Producto AFTER INSERT
AS
BEGIN 
	exec verificar_cumplimiento_combos
END

GO
CREATE TRIGGER trigerActualizadorCombos ON Composicion AFTER INSERT,UPDATE
AS
BEGIN 
	exec verificar_cumplimiento_combos
END

SELECT C.comp_producto,P.prod_precio FROM Composicion C INNER JOIN Producto P ON P.prod_codigo = C.comp_producto


-- OTRA VERSION ABAJO:


--interpreto que el control es manual para cada producto composicion.
GO
CREATE FUNCTION sumatoria_precio_componentes(@codigo_producto_compuesto char(8))
RETURNS decimal(12,2)
AS
BEGIN
	
	DECLARE @componente char(8), @cantidad_componente decimal(12,2)
	DECLARE @sumatoria_precio_componentes decimal(12,2) = 0

	DECLARE cursor_funcion CURSOR FOR
		select 
			C.comp_componente,
			C.comp_cantidad
		from Composicion C 
		where C.comp_producto = @codigo_producto_compuesto

			OPEN cursor_funcion
				FETCH NEXT FROM cursor_funcion INTO @componente, @cantidad_componente
				WHILE(@@FETCH_STATUS = 0)
					BEGIN
						--ACCIONES
						IF NOT EXISTS(SELECT * FROM Composicion C1 WHERE C1.comp_producto = @componente)
							BEGIN	--si no existe , el componente no es un producto compuesto
								set @sumatoria_precio_componentes = @sumatoria_precio_componentes + ((select P.prod_precio from Producto P where P.prod_codigo = @componente) * @cantidad_componente)
							END
						ELSE
							BEGIN -- el componente del producto compuesto, es otro producto compuesto
								set @sumatoria_precio_componentes = @sumatoria_precio_componentes + dbo.sumatoria_precio_componentes(@componente)
							END
						FETCH NEXT FROM cursor_funcion INTO @componente, @cantidad_componente
					END
			CLOSE cursor_funcion
			DEALLOCATE cursor_funcion
	RETURN @sumatoria_precio_componentes
END




------ si el ejericio fuera para corregir los productos composicion manualmente.
GO
CREATE PROCEDURE actualizarPrecioProductoComposicion (@producto_composicion char(8)) 
AS
BEGIN
	SET TRANSACTION ISOLATION LEVEL SERIALIZABLE

	UPDATE Producto
	SET prod_precio = dbo.sumatoria_precio_componentes(@producto_composicion)
	WHERE prod_codigo = @producto_composicion;
END
GO

-- para actualizar todos los productos composicion en un proccedure
GO
CREATE PROCEDURE actualizarPrecioProductoComposicion () 
AS
BEGIN
	declare @comp_producto char(8)
	SET tRaNsACtiOn isolation LEVEL SERIALIZABLE

		DECLARE mi_cursor CURSOR FOR
		SELECT 
			C.comp_producto
		FROM Producto P
			INNER JOIN Composicion C
				ON P.prod_codigo = C.comp_producto 
	
	OPEN mi_cursor
		FETCH NEXT FROM mi_cursor INTO @comp_producto
		while(@@FETCH_STATUS = 0)
			begin
				UPDATE Producto
				SET prod_precio = dbo.sumatoria_precio_componentes(@comp_producto) * 0.9
				WHERE prod_codigo = @comp_producto;

				FETCH NEXT FROM mi_cursor INTO @comp_producto
			end
	CLOSE mi_cursor
	DEALLOCATE mi_cursor
END
GO


-- problema: si actualizan la cantidad en composicion, no se da cuenta
CREATE TRIGGER trigerActualizador ON Producto AFTER INSERT,UPDATE
AS
BEGIN 
	declare @comp_producto char(8)
	SET tRaNsACtiOn isolation LEVEL SERIALIZABLE

		DECLARE mi_cursor CURSOR FOR
		SELECT 
			C.comp_producto
		FROM Producto P
			INNER JOIN Composicion C
				ON P.prod_codigo = C.comp_producto 
	
	OPEN mi_cursor
		FETCH NEXT FROM mi_cursor INTO @comp_producto
		while(@@FETCH_STATUS = 0)
			begin
				--acciones
				UPDATE Producto
				SET prod_precio = dbo.sumatoria_precio_componentes(@comp_producto) * 0.9
				WHERE prod_codigo = @comp_producto;

				FETCH NEXT FROM mi_cursor INTO @comp_producto
			end
	CLOSE mi_cursor
	DEALLOCATE mi_cursor
END






----------------------------------------------------------------------------------------------------------


Select C.comp_producto , 
dbo.sumatoria_precio_componentes(C.comp_producto) as precio_funcion,
C.comp_componente,
P.prod_precio,
C.comp_cantidad,
P.prod_precio * C.comp_cantidad as precioXcantidad
from Composicion C
INNER JOIN Producto P 
	ON P.prod_codigo = C.comp_componente

--select * from Composicion C2 
--	join Producto on C2.comp_producto = prod_codigo





