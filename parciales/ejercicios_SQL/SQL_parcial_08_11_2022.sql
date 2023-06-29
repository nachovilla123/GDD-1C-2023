/* todavia no lo compare con nadie
1. Realizar una consulta SQL que permita saber si un cliente compro un producto en todos los meses del 2012.

Además, mostrar para el 2012: 
1. El cliente
2. La razón social del cliente
3. El producto comprado
4. El nombre del producto
5. Cantidad de productos distintos comprados por el cliente.
6. Cantidad de productos con composición comprados por el cliente.

El resultado deberá ser ordenado poniendo primero aquellos clientes que compraron más de 10 productos distintos en el 2012. 
*/


SELECT 
	CL1.clie_codigo,
	CL1.clie_razon_social,
	--INTERPRETO QUE ES EL PRODUCTO MAS COMPRADO
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
	(
		SELECT TOP 1 P3.prod_detalle  
			FROM Factura F3 
			INNER JOIN Item_Factura I3 
				ON  I3.item_tipo = F3.fact_tipo AND
					I3.item_sucursal = F3.fact_sucursal AND
					I3.item_numero = F3.fact_numero
			INNER JOIN Producto P3 ON P3.prod_codigo = I3.item_producto
			WHERE F3.fact_cliente = CL1.clie_codigo AND YEAR(F3.fact_fecha) = 2012
			GROUP BY I3.item_producto,P3.prod_detalle
			ORDER BY SUM(I3.item_cantidad) DESC

	) AS DETALLE_PRODUCTO_MAS_COMPRADO,
	
	( -- esto esta mal hacer una subquey para esto. Joinear desde el from principal con item factura y hacer un COUNT(DISTINCT I.item_producto) y con eso te ahorras todo esto
		SELECT COUNT(DISTINCT I4.item_producto)
			FROM Factura F4 
			INNER JOIN Item_Factura I4 
				ON  I4.item_tipo = F4.fact_tipo AND
					I4.item_sucursal = F4.fact_sucursal AND
					I4.item_numero = F4.fact_numero
			WHERE F4.fact_cliente = CL1.clie_codigo AND YEAR(F4.fact_fecha) = 2012
	) AS CANTIDAD_PRODUCTOS_DISTINTOS_COMPRADOS,

	(-- INTERPRETO QUE ES LA CANTIDAD DE PRODUCTOS DISTINTOS DE COMPOSICION COMPRO, ES DECIR BIG MAC,BURGUER DOBLE SON 2 PRODS DISTINTOS
		SELECT COUNT(DISTINCT I5.item_producto)
			FROM Factura F5 
			INNER JOIN Item_Factura I5 
				ON  I5.item_tipo = F5.fact_tipo AND
					I5.item_sucursal = F5.fact_sucursal AND
					I5.item_numero = F5.fact_numero
			WHERE F5.fact_cliente = CL1.clie_codigo AND YEAR(F5.fact_fecha) = 2012 AND I5.item_producto IN (
																												SELECT C5.comp_producto FROM Composicion C5
																											)
	) AS CANTIDAD_PRODUCTOS_COMPOSICION


FROM Cliente CL1
	INNER JOIN Factura F1 ON CL1.clie_codigo = F1.fact_cliente
	
WHERE  YEAR(F1.fact_fecha) = 2012
GROUP BY CL1.clie_codigo,CL1.clie_razon_social

HAVING COUNT(DISTINCT MONTH(F1.fact_fecha)) = 12
--saber si un cliente compro un producto en todos los meses del 2012.

ORDER BY 
	CASE WHEN (
		SELECT COUNT(DISTINCT I4.item_producto)
			FROM Factura F4 
			INNER JOIN Item_Factura I4 
				ON  I4.item_tipo = F4.fact_tipo AND
					I4.item_sucursal = F4.fact_sucursal AND
					I4.item_numero = F4.fact_numero
			WHERE F4.fact_cliente = CL1.clie_codigo AND YEAR(F4.fact_fecha) = 2012
	) > 10 THEN  1 
		 ELSE 0 
	END DESC

 

--El resultado deberá ser ordenado poniendo primero aquellos clientes que compraron más de 10 productos distintos en el 2012. 