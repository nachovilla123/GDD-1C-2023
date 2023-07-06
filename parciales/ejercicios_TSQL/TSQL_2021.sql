/*2 fecha que lo tomaron, desconocida, solo se que es del 2021.
 
Realizar un stored procedure que reciba un código de producto y una fecha y devuelva la mayor cantidad de
días consecutivos a partir de esa fecha que el producto tuvo al menos la venta de una unidad en el día, el
sistema de ventas on line está habilitado 24-7 por lo que se deben evaluar todos los días incluyendo domingos y feriados.*/

GO
CREATE PROC punto2 (@producto char(8), 
					@fecha datetime, 
					@max_dias_consecutivos int output)
AS
	DECLARE @dias_consecutivos INT
	DECLARE @fecha_venta DATETIME
	DECLARE @fecha_anterior DATETIME


	SET @max_dias_consecutivos = 0	
	SET @dias_consecutivos = 0
	SET @fecha_anterior = GETDATE()

	declare cVentasDelProducto CURSOR FOR
	select fact_fecha 
	from Factura 
        JOIN Item_Factura 
            ON item_numero+item_tipo+item_sucursal=fact_numero+fact_tipo+fact_sucursal
	WHERE	item_producto = @producto AND fact_fecha > @fecha
	GROUP BY fact_fecha
	ORDER BY fact_fecha ASC

	open cVentasDelProducto
        FETCH NEXT FROM cVentasDelProducto INTO @fecha_venta
        WHILE @@FETCH_STATUS = 0
            BEGIN
                if(@fecha_venta = dateadd(day, 1, @fecha_anterior))
                    begin
                        SET @dias_consecutivos = @dias_consecutivos + 1
                    end
                else
                    begin
                        if(@dias_consecutivos > @max_dias_consecutivos)
                            begin
                                set @max_dias_consecutivos = @dias_consecutivos
                            end
                        SET @dias_consecutivos = 0
                    end
                
                set @fecha_anterior = @fecha_venta
                FETCH NEXT FROM cVentasDelProducto INTO @fecha_venta
            END
	CLOSE cVentasDelProducto
	DEALLOCATE cVentasDelProducto

	return @max_dias_consecutivos
GO