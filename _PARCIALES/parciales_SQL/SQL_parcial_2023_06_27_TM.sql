/*
I.Realizar una consulta SQL que retorne para 

█ todas las zonas que tengan 3 (tres) o más depósitos.

	█ Detalle Zona
	█ Cantidad de Depósitos x Zona
█? Cantidad de Productos distintos compuestos en sus depósitos
█? Producto mas vendido en el año 2012 que tonga stock en al menos uno de sus depósitos.
█?	Mejor encargado perteneciente a esa zona (El que mas vendió en la historia).

El resultado deberá ser ordenado por monto total vendido del encargado DESC.

zona--> deposito --> Stock
*/


SELECT 
	Z.zona_codigo,
	Z.zona_detalle,
	COUNT(DISTINCT D.depo_codigo) AS Depositos_X_Zona
	,
	(
		select count(distinct C1.comp_producto) 
			from Composicion C1 
				INNER JOIN STOCK S1 
					ON S1.stoc_producto = C1.comp_producto
				INNER JOIN DEPOSITO D1 
					ON D1.depo_codigo = S1.stoc_deposito
				INNER JOIN ZONA Z1
					ON D1.depo_zona = Z1.zona_codigo
			WHERE  Z1.zona_codigo = Z.zona_codigo
			--GROUP BY C1.comp_producto PORQ NO VA ESTO? A BORDA
	) AS CANT_PRODUCTOS_COMPOSICION_DISTINTOS_EN_DEPOSITOS,
	(	-- PORQUE ME DA DISTINTO AL DE SANTI?
		SELECT TOP 1 I2.item_producto

		FROM Factura F2
			INNER JOIN Item_Factura I2 
				ON F2.fact_tipo+F2.fact_sucursal+F2.fact_numero = I2.item_tipo+I2.item_sucursal+I2.item_numero
			INNER JOIN Producto P2 
				ON I2.item_producto = P2.prod_codigo
			INNER JOIN STOCK S2
				ON S2.stoc_producto = P2.prod_codigo
			INNER JOIN DEPOSITO D2 
				ON D2.depo_codigo = S2.stoc_deposito
		WHERE D2.depo_zona = Z.zona_codigo AND YEAR(F2.fact_fecha) = 2012
		GROUP BY I2.item_producto
		ORDER BY SUM(I2.item_cantidad) DESC
	) AS PRODUCTO_MAS_VENDIDO_2012,
	(
		SELECT TOP 1 E3.empl_codigo 
		FROM Empleado E3
			INNER JOIN Factura F3 
				ON F3.fact_vendedor = E3.empl_codigo
		WHERE E3.empl_codigo  IN (
										SELECT D3.depo_encargado FROM DEPOSITO D3 
										WHERE D3.depo_zona = Z.zona_codigo
								)
		GROUP BY E3.empl_codigo,F3.fact_vendedor 
		ORDER BY SUM(F3.fact_total) DESC
			
	) AS MEJOR_VENDEDOR,
	(
		SELECT TOP 1 SUM(F3.fact_total) 
		FROM Empleado E3
			INNER JOIN Factura F3 
				ON F3.fact_vendedor = E3.empl_codigo
		WHERE E3.empl_codigo  IN (
										SELECT D3.depo_encargado FROM DEPOSITO D3 
										WHERE D3.depo_zona = Z.zona_codigo
								)
		GROUP BY E3.empl_codigo,F3.fact_vendedor 
		ORDER BY SUM(F3.fact_total) DESC
			
	) AS TOTAL_MEJOR_VENDEDOR

FROM DEPOSITO D 
	INNER JOIN Zona Z
		ON Z.zona_codigo = D.depo_zona
GROUP BY Z.zona_codigo,Z.zona_detalle
HAVING COUNT(DISTINCT D.depo_codigo) >= 3

ORDER BY  (
(
		SELECT TOP 1 SUM(F3.fact_total) 
		FROM Empleado E3
			INNER JOIN Factura F3 
				ON F3.fact_vendedor = E3.empl_codigo
		WHERE E3.empl_codigo  IN (
										SELECT D3.depo_encargado FROM DEPOSITO D3 
										WHERE D3.depo_zona = Z.zona_codigo
								)
		GROUP BY E3.empl_codigo,F3.fact_vendedor 
		ORDER BY SUM(F3.fact_total) DESC
			
	) 
) DESC