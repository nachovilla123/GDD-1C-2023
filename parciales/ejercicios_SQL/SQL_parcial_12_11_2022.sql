/* Realizar una consulta SQL que permita saber los clientes que
compraron por encima del promedio de compras (fact_total) de todos
los clientes del 2012.

De estos clientes mostrar para el 2012:
1.El código del cliente
2.La razón social del cliente
3.Código de producto que en cantidades más compro.
4,El nombre del producto del punto 3.
5,Cantidad de productos distintos comprados por el cliente,
6.Cantidad de productos con composición comprados por el cliente,

EI resultado deberá ser ordenado poniendo primero aquellos clientes
que compraron más de entre 5 y 10 productos distintos en el 2012 */


SELECT
	c.clie_codigo,
	c.clie_razon_social,

	ISNULL(
	(
		SELECT TOP 1 i3.item_producto
		FROM Item_Factura i3
			INNER JOIN Factura f3 ON
			i3.item_tipo = f3.fact_tipo AND i3.item_sucursal = f3.fact_sucursal AND i3.item_numero = f3.fact_numero
		WHERE YEAR(f3.fact_fecha) = 2012 AND f3.fact_cliente = c.clie_codigo
		GROUP BY i3.item_producto
		ORDER BY SUM(i3.item_cantidad) DESC
	),'NO HAY PRODUCTO') AS codigo_producto_mas_comprado,


	ISNULL((
	SELECT TOP 1 p5.prod_detalle
	FROM Item_Factura i5
	INNER JOIN Factura f5 ON
		i5.item_tipo = f5.fact_tipo
		AND i5.item_sucursal = f5.fact_sucursal
		AND i5.item_numero = f5.fact_numero
	INNER JOIN Producto p5 ON
		i5.item_producto = p5.prod_codigo
	WHERE
		YEAR(f5.fact_fecha) = 2012
		AND f5.fact_cliente = c.clie_codigo
	GROUP BY
		i5.item_producto,
		p5.prod_detalle
	ORDER BY
		SUM(i5.item_cantidad) DESC),
	'NO HAY PRODUCTO') AS detalle_producto_mas_comprado,

	COUNT(DISTINCT i.item_producto) AS productos_distintos,

	COUNT(DISTINCT C2.comp_producto) AS productos_compuestos

FROM Cliente c
INNER JOIN Factura f 
	ON c.clie_codigo = f.fact_cliente
INNER JOIN Item_Factura i 
	ON f.fact_tipo = i.item_tipo AND f.fact_sucursal = i.item_sucursal AND f.fact_numero = i.item_numero
LEFT JOIN Composicion C2 ON
    C2.comp_producto = I.item_producto
WHERE YEAR(f.fact_fecha) = 2012
GROUP BY c.clie_codigo, c.clie_razon_social
HAVING
	(
	SELECT SUM(f.fact_total)
	FROM Factura f
	WHERE f.fact_cliente = c.clie_codigo
		AND YEAR(f.fact_fecha) = 2012) > 
		(
			SELECT AVG(f2.fact_total)
			FROM Factura f2
			WHERE YEAR(f2.fact_fecha) = 2012 
		)
ORDER BY c.clie_codigo
	--CASE
	--	WHEN COUNT(DISTINCT i.item_producto) BETWEEN 5 AND 10 THEN 1
	--	ELSE 2
	--END ASC