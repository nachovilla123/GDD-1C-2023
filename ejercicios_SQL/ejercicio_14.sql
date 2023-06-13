/*
14. Escriba una consulta que retorne una estadística de ventas por cliente. Los campos que debe retornar son:
Código del cliente
Cantidad de veces que compro en el último año
Promedio por compra en el último año
Cantidad de productos diferentes que compro en el último año
Monto de la mayor compra que realizo en el último año
Se deberán retornar todos los clientes ordenados por la cantidad de veces que compro enel último año.
No se deberán visualizar NULLs en ninguna columna
*/

SELECT F.fact_cliente AS CLIENTE,
	   COUNT (F.fact_cliente) AS [CANTIDAD DE COMPRAS],
	   AVG(F.fact_total) AS [PRECIO PROMEDIO POR COMPRA],
	   COUNT (DISTINCT I.item_producto) [CANTIDAD DE PRODUCTOS DISTINTOS COMPRADOS],
	   MAX(F.fact_total) AS [MONTO MAYOR COMPRA]

FROM Factura F 
JOIN Item_Factura I ON I.item_tipo = F.fact_tipo AND I.item_sucursal = F.fact_sucursal AND I.item_numero = F.fact_numero
--WHERE YEAR(F.fact_fecha) = YEAR(GETDATE()) - 1
GROUP BY F.fact_cliente

ORDER BY COUNT (F.fact_cliente) DESC


--  version mia lo de abajo.

/*
14. Escriba una consulta que retorne una estadística de ventas por cliente. Los campos que debe retornar son:
Código del cliente *
Cantidad de veces que compro en el último año*
Promedio por compra en el último año*
Cantidad de productos diferentes que compro en el último año*
Monto de la mayor compra que realizo en el último año*
Se deberán retornar todos los clientes ordenados por la cantidad de veces que compro en el último año.
No se deberán visualizar NULLs en ninguna columna
*/

SELECT 
	YEAR(F.fact_fecha) AS ANIO,
	F.fact_cliente AS CODIGO_CLIENTE,
	AVG(F.fact_total) AS PROMEDIO_POR_COMPRA,
	COUNT(F.fact_cliente) AS CANTIDAD_COMPRAS_ANIO,
	COUNT(DISTINCT I.item_producto) AS PROD_DISTINTOS_ANIO,
	(
		SELECT TOP 1 F2.fact_total FROM Factura F2 
		WHERE YEAR(F2.fact_fecha) = YEAR(F.fact_fecha) AND F2.fact_cliente = F.fact_cliente
		ORDER BY F2.fact_total DESC
	) AS MONTO_MAYOR_COMPRA

FROM Factura F 
JOIN Item_Factura I ON F.fact_tipo+F.fact_sucursal+F.fact_numero = I.item_tipo+I.item_sucursal+I.item_numero
GROUP BY YEAR(F.fact_fecha),F.fact_cliente
ORDER BY YEAR(F.fact_fecha),COUNT(F.fact_cliente) DESC