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

	( --TODO joinear con item factura y COUNT(DISTINCT I.item_producto)
		SELECT COUNT(DISTINCT I4.item_producto)
			FROM Factura F4 
			INNER JOIN Item_Factura I4 
				ON  I4.item_tipo = F4.fact_tipo AND
					I4.item_sucursal = F4.fact_sucursal AND
					I4.item_numero = F4.fact_numero
			WHERE F4.fact_cliente = CL1.clie_codigo AND YEAR(F4.fact_fecha) = 2012
	) AS CANTIDAD_PRODUCTOS_DISTINTOS_COMPRADOS,

	(
		SELECT SUM( F5.fact_total)
			FROM Factura F5 
			WHERE F5.fact_cliente = CL1.clie_codigo AND YEAR(F5.fact_fecha) = 2012
	) AS MONTO_TOTAL_COMPRADO

FROM Cliente CL1
	INNER JOIN Factura F1 ON CL1.clie_codigo = F1.fact_cliente
	WHERE  YEAR(F1.fact_fecha) = 2012
GROUP BY CL1.clie_codigo

HAVING  ( -- DUDAS
			SELECT COM.comp_producto
			FROM Composicion COM 
		) IN 
			(
				SELECT IH.item_producto 
					FROM Factura FH 
						INNER JOIN Item_Factura IH 
							ON  IH.item_tipo = FH.fact_tipo AND
								IH.item_sucursal = FH.fact_sucursal AND
								IH.item_numero = FH.fact_numero
					WHERE FH.fact_cliente = CL1.clie_codigo AND YEAR(FH.fact_fecha) = 2012
			)

--Realizar una consulta SQL que permita saber los clientes que compraron en el 2012 al menos 1 unidad de todos los productos compuestos.


