/*█:DONE

I, Realizar una consulta SQL que permita saber 

	los clientes que compraron todos los rubros disponibles del sistema en el 2012.

█De estos clientes mostrar, siempre para el 2012: 

	█1.El código del cliente
	█2.Código de producto que en cantidades más compro.
	█3.El nombre del producto del punto 2.

	█4,Cantidad de productos distintos comprados por el cliente.

	█5.Cantidad de productos con composición comprados por el cliente.

El resultado deberá ser ordenado por razón social del cliente
alfabéticamente primero y luego, los clientes que compraron entre un
20 % y 30% del total facturado en el 2012 primero, luego, los restantes,
*/


SELECT 
	CL.clie_codigo,
	(
		select top 1 I1.item_producto
		from Factura F1
			inner join Item_Factura I1
				on F1.fact_tipo+F1.fact_sucursal+F1.fact_numero=I1.item_tipo+I1.item_sucursal+I1.item_numero
			where F1.fact_cliente = CL.clie_codigo AND YEAR(F1.fact_fecha) = 2012
		GROUP BY I1.item_producto
		ORDER BY SUM(I1.item_cantidad) DESC
	) AS CODIGO_PRODUCTO_MAS_COMPRADO,
	(
		select top 1 P2.prod_detalle
		from Factura F2
			inner join Item_Factura I2
				on F2.fact_tipo+F2.fact_sucursal+F2.fact_numero=I2.item_tipo+I2.item_sucursal+I2.item_numero
			inner join Producto P2 
				on P2.prod_codigo = I2.item_producto
			where F2.fact_cliente = CL.clie_codigo AND YEAR(F2.fact_fecha) = 2012
			
		GROUP BY I2.item_producto,P2.prod_detalle
		ORDER BY SUM(I2.item_cantidad) DESC
	) AS DETALLE_PRODUCTO_MAS_COMPRADO,
	COUNT(DISTINCT I.item_producto) AS [Cantidad de productos distintos comprados por el cliente],
	COUNT(DISTINCT CC.comp_producto)  AS [5.Cantidad de productos con composición comprados por el cliente.]

FROM Cliente CL
	INNER JOIN Factura F 
		ON F.fact_cliente = CL.clie_codigo
	INNER JOIN Item_Factura I
		ON F.fact_tipo+F.fact_sucursal+F.fact_numero=I.item_tipo+I.item_sucursal+I.item_numero
	INNER JOIN Producto PD
		ON PD.prod_codigo = I.item_producto
	LEFT JOIN Composicion CC 
		ON CC.comp_producto = I.item_producto
WHERE YEAR(F.fact_fecha) = 2012
GROUP BY CL.clie_codigo, CL.clie_razon_social
--HAVING COUNT (DISTINCT PD.prod_rubro) = ( SELECT COUNT( R.rubr_id) FROM Rubro R)  creo q esto ta bien pero no hay productos en db para testear
ORDER BY CL.clie_razon_social ASC , 
	( case when sum(F.fact_total)
				 BETWEEN ((SELECT SUM(FT.fact_total) 
						FROM Factura FT
						WHERE YEAR(FT.fact_fecha) = 2012) * 0.2) and ((SELECT SUM(FT.fact_total) 
						FROM Factura FT
						WHERE YEAR(FT.fact_fecha) = 2012) * 0.3)   then 1 
						ELSE 0
	end) ASC

    