
FALTA CORREGIR CON BORDA 

/*
11. Realizar una consulta que retorne 
el detalle de la familia,
 la cantidad diferentes de productos vendidos y
  el monto de dichas ventas sin impuestos. 
  
  Los datos se deberán ordenar de mayor a menor, por la familia que más productos diferentes vendidos tenga,
	
	solo se deberán mostrar las familias que tengan una venta superior a 20000 pesos para
el año 2012.
*/

SELECT 
	FL.fami_detalle AS DETALLE_FAMILIA,
	COUNT(DISTINCT I.item_producto) AS PRODUCTOS_DIFERENTES_VENDIDOS,
	SUM(ISNULL(F.fact_total,0)) - SUM(ISNULL(F.fact_total_impuestos,0)) as MontoVentaSinImpuestos
	FROM Factura F 
	JOIN Item_Factura I 
		ON F.fact_tipo+F.fact_sucursal+F.fact_numero=I.item_tipo+I.item_sucursal+I.item_numero
	JOIN Producto P 
		ON P.prod_codigo = I.item_producto
	JOIN Familia FL ON FL.fami_id = P.prod_familia
	where YEAR(F.fact_fecha) = 2012
	
	GROUP BY FL.fami_detalle,I.item_producto, FL.fami_id
	having SUM(ISNULL(F.fact_total,0)) > 20000
	order by COUNT(DISTINCT P.prod_codigo) DESC