/*I.  

	►AUN NO COMPARADO CON OTRA PERSONA

Realizar una consulta SQL que permita saber los clientes que compraron en el 2012 al menos 1 unidad de todos los productos compuestos.

De estos clientes mostrar, siempre para el 2012:
		►I. El código del cliente
		►2. Código de producto que en cantidades más compro.
?? 3. El número de fila según el orden establecido con un alias llamado ORDINAL. 
		►4. Cantidad de productos distintos comprados por el cliente.
		►5. Monto total comprado.

El resultado deberá ser ordenado por razón social del cliente
alfabéticamente primero y luego, los clientes que compraron entre un
20 % y 30% del total facturado en el 2012 primero, luego, los restantes.*/

SELECT
	CL1.clie_codigo,
	(
		SELECT TOP 1 I2.item_producto  
			FROM Factura F2 
			INNER JOIN Item_Factura I2 
				ON  I2.item_tipo = F2.fact_tipo AND
					I2.item_sucursal = F2.fact_sucursal AND
					I2.item_numero = F2.fact_numero
			WHERE F2.fact_cliente = CL1.clie_codigo AND YEAR(F2.fact_fecha) = 2012
			GROUP BY I2.item_producto
			ORDER BY SUM(I2.item_cantidad) DESC

	) AS CODIGO_PRODUCTO_MAS_COMPRADO,

	COUNT(DISTINCT I1.item_producto) AS CANTIDAD_PRODUCTOS_DISTINTOS_COMPRADOS,

	SUM(F1.fact_total) AS MONTO_TOTAL_COMPRADO,
	COUNT(DISTINCT COMPO.comp_producto)

FROM Cliente CL1
	INNER JOIN Factura F1 
		ON CL1.clie_codigo = F1.fact_cliente
	INNER JOIN Item_Factura I1 
		ON F1.fact_tipo+F1.fact_sucursal+F1.fact_numero=I1.item_tipo+I1.item_sucursal+I1.item_numero
	LEFT JOIN Composicion COMPO
		ON COMPO.comp_producto = I1.item_producto
		
WHERE  YEAR(F1.fact_fecha) = 2012
GROUP BY CL1.clie_codigo
HAVING  (-- ESTA BIEN HECHO PERO NO HAY PRODUCTOS Q CUMPLAN CONDICION
			SELECT COUNT(DISTINCT COM.comp_producto)
			FROM Composicion COM 
		) = COUNT(DISTINCT COMPO.comp_producto)
--ORDER BY PENDIENTE :(
		




