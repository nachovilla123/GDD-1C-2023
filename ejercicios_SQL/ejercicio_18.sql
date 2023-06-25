/*

EMPEZANDOLO SIN TERMINAR


18. Escriba una consulta que retorne una estadística de ventas para todos los rubros.
La consulta debe retornar:
DETALLE_RUBRO: Detalle del rubro
VENTAS: Suma de las ventas en pesos de productos vendidos de dicho rubro
PROD1: Código del producto más vendido de dicho rubro
PROD2: Código del segundo producto más vendido de dicho rubro
CLIENTE: Código del cliente que compro más productos del rubro en los últimos 30
días
La consulta no puede mostrar NULL en ninguna de sus columnas y debe estar ordenada
por cantidad de productos diferentes vendidos del rubro.
*/



select 
	R.rubr_detalle as DetalleRubro,
	(
		Select Sum(I2.item_cantidad * I2.item_precio) from Item_Factura I2 
			JOIN Producto P2 ON I2.item_producto = P2.prod_codigo
				where I2.item_tipo+I2.item_sucursal+I2.item_numero = F.fact_tipo+F.fact_sucursal+F.fact_numero AND
					  P2.prod_rubro = R.rubr_id			
	) AS VENTAS_EN_PESOS_RUBRO,
	(SELECT TOP 1 COUNT(F3.fact_cliente) FROM Factura F3 
		JOIN Item_Factura I3 ON
	GROUP BY F3.fact_cliente )
		FROM Rubro R 
		LEFT JOIN Producto P ON P.prod_rubro = R.rubr_id
		RIGHT JOIN Item_Factura I ON I.item_producto = P.prod_codigo
		JOIN Factura F ON F.fact_tipo+F.fact_sucursal+F.fact_numero=I.item_tipo+I.item_sucursal+I.item_numero
		GROUP BY R.rubr_id,R.rubr_detalle , F.fact_tipo,F.fact_sucursal,F.fact_numero