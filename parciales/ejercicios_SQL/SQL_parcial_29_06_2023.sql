/*
realiza una consulta SQL que devuelva todos los clientes que durante
2 aaños consecutivos compraron al menos 5 productos  distintos. 
De esos clientes mostrar.
• codigo cliente
• El monto total comprado en el 2012
• La cantidad de unidades de productos compradas  en el 2012

El resultado debe ser ordenado primero por aquellos clientes que compraron
solo productos compuestos en algún momento, luego el resto.
*/

SELECT
	c.clie_codigo
	,(
		SELECT SUM(f4.fact_total) FROM Factura f4
		WHERE f4.fact_cliente = c.clie_codigo AND YEAR(f4.fact_fecha) = 2012
	) monto_total_2012
	,(
		SELECT SUM(it2.item_cantidad) FROM Item_Factura it2
		JOIN Factura f5 ON f5.fact_numero = it2.item_numero AND f5.fact_sucursal = it2.item_sucursal AND f5.fact_tipo = it2.item_tipo
		WHERE f5.fact_cliente = c.clie_codigo AND YEAR(f5.fact_fecha) = 2012
	) cantidad_unidades_compradas_2012

FROM Cliente c
JOIN Factura f ON f.fact_cliente = c.clie_codigo
WHERE	5 <= (
				SELECT 
					COUNT(DISTINCT it.item_producto)
				FROM Item_Factura it
				INNER JOIN Factura f2 ON f2.fact_numero = it.item_numero AND f2.fact_sucursal = it.item_sucursal AND f2.fact_tipo = it.item_tipo
				WHERE YEAR(f2.fact_fecha) = YEAR(f.fact_fecha) AND f2.fact_cliente = c.clie_codigo
			 ) AND
		5 <= (
				SELECT 
					COUNT(DISTINCT it.item_producto)
				FROM Item_Factura it
				INNER JOIN Factura f3 ON f3.fact_numero = it.item_numero AND f3.fact_sucursal = it.item_sucursal AND f3.fact_tipo = it.item_tipo
				WHERE YEAR(f3.fact_fecha) = YEAR(f.fact_fecha) + 1 AND f3.fact_cliente = c.clie_codigo
			 )
GROUP by c.clie_codigo
ORDER BY 
	CASE WHEN(
			SELECT COUNT(it3.item_producto)
			FROM Item_Factura it3
			INNER JOIN Factura f6 ON f6.fact_numero = it3.item_numero AND f6.fact_sucursal = it3.item_sucursal AND f6.fact_tipo = it3.item_tipo
			WHERE f6.fact_cliente = '00656' AND it3.item_producto NOT IN (SELECT comp_producto FROM Composicion) 
	) = 0 THEN 1 ELSE 0 END DESC