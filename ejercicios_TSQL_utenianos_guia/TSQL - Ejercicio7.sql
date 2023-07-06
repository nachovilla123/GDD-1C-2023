/*7. Hacer un procedimiento que dadas dos fechas complete la tabla Ventas. Debe
insertar una línea por cada artículo con los movimientos de stock generados por
las ventas entre esas fechas. La tabla se encuentra creada y vacía.*/

IF OBJECT_ID('Ventas','U') IS NOT NULL 
DROP TABLE Ventas
GO
Create table Ventas
(
vent_codigo char(8) NULL, --Código del articulo
vent_detalle char(50) NULL, --Detalle del articulo
vent_movimientos int NULL, --Cantidad de movimientos de ventas (Item Factura)
vent_precio_prom decimal(12,2) NULL, --Precio promedio de venta
vent_renglon int IDENTITY(1,1) PRIMARY KEY, --Nro de linea de la tabla (PK)
vent_ganancia char(6) NOT NULL, --Precio de venta - Cantidad * Costo Actual
)
/*
Alter table Ventas
Add constraint pk_ventas_ID primary key(vent_renglon)
GO*/

if OBJECT_ID('Ejercicio7','P') is not null
DROP PROCEDURE Ejercicio7
GO

CREATE PROCEDURE Ejercicio7 (@StartingDate date, @FinishingDate date)
AS
BEGIN
	DECLARE @Codigo char(8), @Detalle char(50), @Cant_Mov int, @Precio_de_venta decimal(12,2), @Renglon int, @Ganancia decimal(12,2)
	DECLARE cursor_articulos CURSOR
		FOR SELECT prod_codigo
			,prod_detalle
			,SUM(item_cantidad)
			,AVG(item_precio)
			,SUM(item_cantidad*item_precio)
			FROM Producto
				INNER JOIN Item_Factura
					ON item_producto = prod_codigo
				INNER JOIN Factura
					ON fact_tipo = item_tipo AND fact_sucursal = fact_sucursal AND fact_numero = item_numero
			WHERE fact_fecha BETWEEN @StartingDate AND @FinishingDate
			GROUP BY prod_codigo,prod_detalle

		OPEN cursor_articulos
		SET @renglon = 0

		FETCH NEXT FROM cursor_articulos
		INTO @Codigo,@Detalle,@Cant_Mov,@Precio_de_venta,@Ganancia

		WHILE @@FETCH_STATUS = 0
		BEGIN
			--SET @Renglon = @Renglon + 1
			INSERT INTO Ventas
			VALUES (@Codigo,@Detalle,@Cant_Mov,@Precio_de_venta,@Ganancia)
			FETCH NEXT FROM cursor_articulos
			INTO @Codigo,@Detalle,@Cant_Mov,@Precio_de_venta,@Ganancia
		END
		CLOSE cursor_articulos
		DEALLOCATE cursor_articulos
	END
GO


/*
EXEC Ejercicio7 '2012-01-01','2012-07-01'

select * from Factura
order by fact_fecha desc

select * from ventas*/