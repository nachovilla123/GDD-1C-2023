/*
1. Realizar una consulta SOL que retorne para los 10 clientes que más
compraron en el 2012 y que fueron atendldos por más de 3 vendedores
distintos:

█• Apellido y Nombro del Cliento.
█• Cantidad de Productos distmtos comprados en el 2012,
• Cantidad de unidades compradas dentro del pomer semestre del 2012.

•El resultado deberá mostrar ordenado ta cantidad de ventas descendente
	del 2012 de cada cliente, en caso de igualdad de ventasi ordenar porcódigo de cliente.

NOTA: No se permite el uso de sub-setects en el FROM ni funciones definidas por el usuario para este punto,
*/

SELECT TOP 10 
C.clie_razon_social as [Cliente-Razon Social],
COUNT(DISTINCT IT.item_producto) as [Unidades compradas Semestral],
(
SELECT
SUM(IT2.item_cantidad)
FROM Factura F2
	INNER JOIN Item_Factura IT2 ON
		F2.fact_tipo+F2.fact_numero+F2.fact_sucursal = IT2.item_tipo+IT2.item_numero+IT2.item_sucursal
	WHERE F2.fact_cliente = F.fact_cliente AND YEAR(F2.fact_fecha) = 2012 AND MONTH(F2.fact_fecha) <=6
) as [Producos del primer semestre]
FROM Factura F
	INNER JOIN Cliente C ON
		C.clie_codigo = F.fact_cliente
	INNER JOIN Item_Factura IT ON
		F.fact_tipo+F.fact_numero+F.fact_sucursal = IT.item_tipo+IT.item_numero+IT.item_sucursal
	WHERE YEAR(F.fact_fecha) = 2012
	GROUP BY F.fact_cliente,C.clie_razon_social,C.clie_codigo
	--HAVING COUNT(DISTINCT F.fact_vendedor) > 3
	ORDER BY COUNT(F.fact_cliente)DESC ,C.clie_codigo DESC