/*
15. Escriba una consulta que retorne los pares de productos que hayan sido vendidos juntos
(en la misma factura) más de 500 veces. 

El resultado debe mostrar el código y descripción de cada uno de los productos y la cantidad de veces que fueron vendidos
juntos. 

El resultado debe estar ordenado por la cantidad de veces que se vendieron juntos dichos productos. 

Los distintos pares no deben retornarse más de una vez.

Ejemplo de lo que retornaría la consulta:

PROD1 DETALLE1 PROD2 DETALLE2 VECES
1731 MARLBORO KS 1 7 1 8 P H ILIPS MORRIS KS 5 0 7
1718 PHILIPS MORRIS KS 1 7 0 5 P H I L I P S MORRIS BOX 10 5 6 2
*/

SELECT 
	P1.prod_codigo AS CODIGO_PROD1,
	P1.prod_detalle AS DETALLE_PROD1,
	P2.prod_codigo AS CODIGO_PROD2,
	P2.prod_detalle AS DETALLE_PROD2,
	COUNT(*) AS VECES
FROM Factura F 

	JOIN Item_Factura I1 ON I1.item_tipo = F.fact_tipo AND
						   I1.item_sucursal = F.fact_sucursal AND
						   I1.item_numero = F.fact_numero
	JOIN Producto P1 ON P1.prod_codigo = I1.item_producto

	JOIN Item_Factura I2 ON I2.item_tipo = F.fact_tipo AND
							I2.item_sucursal = F.fact_sucursal AND
							I2.item_numero = F.fact_numero
	JOIN Producto P2 ON P2.prod_codigo = I2.item_producto

-- mi ejercicio 15, no se si esta bien