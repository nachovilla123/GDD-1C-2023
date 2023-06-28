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
	CL.clie_codigo,
	Cl.clie_razon_social,
	COUNT(DISTINCT I.item_producto) AS Productos_distintos_comprados_2012,
	isnull((
		Select Sum(I2.item_cantidad)
		From Factura F2
			INNER JOIN Item_Factura I2
				ON I2.item_tipo+I2.item_sucursal+I2.item_numero = F2.fact_tipo+F2.fact_sucursal+F2.fact_numero
		WHERE F2.fact_cliente = CL.clie_codigo AND F2.fact_fecha >= CONVERT(DATETIME, '2012-01-01 00:00:00', 120)
            AND F2.fact_fecha <= CONVERT(DATETIME, '2012-06-30 23:59:59', 120)
		
	),0) as Cantidad_unidades_compradas_primer_semestre_2012

FROM Cliente CL 
	INNER JOIN Factura F
		ON F.fact_cliente = Cl.clie_codigo
	Inner Join Item_Factura I on I.item_tipo+I.item_sucursal+I.item_numero = F.fact_tipo+F.fact_sucursal+F.fact_numero
WHERE F.fact_fecha >= CONVERT(DATETIME, '2012-01-01 00:00:00', 120)
    AND F.fact_fecha <= CONVERT(DATETIME, '2012-12-31 23:59:59', 120)
group by CL.clie_codigo,Cl.clie_razon_social
--HAVING COUNT(DISTINCT F.fact_vendedor) > 3
ORDER BY Productos_distintos_comprados_2012 DESC , CL.clie_codigo