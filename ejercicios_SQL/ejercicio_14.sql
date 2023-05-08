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