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

--IP.item_producto
SELECT F1.fact_cliente,
	   CL.clie_razon_social,
	   (
			SELECT TOP 1 IP.item_producto FROM Factura FP
			JOIN Item_Factura IP ON IP.item_tipo+IP.item_sucursal+IP.item_numero = FP.fact_tipo+FP.fact_sucursal+FP.fact_numero
			WHERE FP.fact_cliente = F1.fact_cliente AND YEAR(FP.fact_fecha) = 2012
			GROUP BY IP.item_producto
			ORDER BY SUM(ISNULL(IP.item_cantidad,0)) DESC	
	   ) AS CODIGO_PROD_MAS_CANTIDAD_COMPRO,
	   (
			SELECT TOP 1 PP.prod_detalle FROM Factura FP
			INNER JOIN Item_Factura IP ON IP.item_tipo+IP.item_sucursal+IP.item_numero = FP.fact_tipo+FP.fact_sucursal+FP.fact_numero
			INNER JOIN Producto PP ON IP.item_producto = PP.prod_codigo
			WHERE FP.fact_cliente = F1.fact_cliente AND YEAR(FP.fact_fecha) = 2012
			GROUP BY PP.prod_detalle
			ORDER BY SUM(ISNULL(IP.item_cantidad,0)) DESC	
	   ) AS DETALLE_PROD_MAS_CANTIDAD_COMPRO,
	   (
		SELECT  COUNT(DISTINCT IC.item_producto) FROM Factura FC
			INNER JOIN Item_Factura IC ON IC.item_tipo+IC.item_sucursal+IC.item_numero = FC.fact_tipo+FC.fact_sucursal+FC.fact_numero
			WHERE FC.fact_cliente = F1.fact_cliente AND YEAR(FC.fact_fecha) = 2012
	   ) AS CANTIDAD_PRODUCTOS_DISTINTOS_COMPRADOS
	   ,
	   ( -- 6.Cantidad de productos con composición comprados por el cliente
		SELECT COUNT(DISTINCT CC.comp_producto) FROM Composicion CC	
			LEFT JOIN Producto PC ON CC.comp_producto = PC.prod_codigo 
			LEFT JOIN Item_Factura ICC ON ICC.item_producto = CC.comp_producto
			LEFT JOIN Factura FCC ON ICC.item_tipo+ICC.item_sucursal+ICC.item_numero = FCC.fact_tipo+FCC.fact_sucursal+FCC.fact_numero
		WHERE FCC.fact_cliente = F1.fact_cliente AND YEAR(FCC.fact_fecha) = 2012
	   ) AS CANTIDAD_PRODUCTOS_CON_COMPOSICION

	 FROM Factura F1
	LEFT JOIN Cliente CL ON F1.fact_cliente = CL.clie_codigo
	WHERE YEAR(F1.fact_fecha) = 2012
	GROUP BY F1.fact_cliente,CL.clie_razon_social
	HAVING (SUM(F1.fact_total) > (
									SELECT AVG(FProm.fact_total) FROM Factura FProm 
									WHERE YEAR(FProm.fact_fecha) = 2012 
									GROUP BY YEAR(FProm.fact_fecha)
									))
	ORDER BY F1.fact_cliente 

--EI resultado deberá ser ordenado poniendo primero aquellos clientes
--que compraron más de entre 5 y 10 productos distintos en el 2012 


--Promedio de compras del 2012
--SELECT AVG(FProm.fact_total) FROM Factura FProm 
--	WHERE YEAR(FProm.fact_fecha) = 2012 
--	GROUP BY YEAR(FProm.fact_fecha);



--------------------------------------resuelto del tipo-----------------------------------------------------------


SELECT
	c.clie_codigo,
	c.clie_razon_social,



	ISNULL((
	SELECT
		TOP 1 i3.item_producto
	FROM
		Item_Factura i3
	INNER JOIN Factura f3 ON
		i3.item_tipo = f3.fact_tipo
		AND i3.item_sucursal = f3.fact_sucursal
		AND i3.item_numero = f3.fact_numero
	WHERE
		YEAR(f3.fact_fecha) = 2012
		AND f3.fact_cliente = c.clie_codigo
	GROUP BY
		i3.item_producto
	ORDER BY
		SUM(i3.item_cantidad) DESC),
	'NO HAY PRODUCTO') AS codigo_producto_mas_comprado,





	ISNULL((
	SELECT
		TOP 1 p5.prod_detalle
	FROM
		Item_Factura i5
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


	ISNULL((
	SELECT
		COUNT(DISTINCT i4.item_producto)
	FROM
		Item_Factura i4
	INNER JOIN Factura f4 ON
		i4.item_tipo = f4.fact_tipo
		AND i4.item_sucursal = f4.fact_sucursal
		AND i4.item_numero = f4.fact_numero
	WHERE
		YEAR(f4.fact_fecha) = 2012
		AND f4.fact_cliente = c.clie_codigo
		AND i4.item_producto IN (
		SELECT DISTINCT comp_producto
		FROM Composicion c)
	GROUP BY
		f4.fact_cliente),
	0) AS cantidad_productos_compuestos


FROM Cliente c
INNER JOIN Factura f ON
	c.clie_codigo = f.fact_cliente
INNER JOIN Item_Factura i ON
	f.fact_tipo = i.item_tipo
	AND f.fact_sucursal = i.item_sucursal
	AND f.fact_numero = i.item_numero
WHERE
	YEAR(f.fact_fecha) = 2012
GROUP BY
	c.clie_codigo,
	c.clie_razon_social
HAVING
	(
	SELECT SUM(f.fact_total)
	FROM Factura f
	WHERE
		f.fact_cliente = c.clie_codigo
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