
/*10. Mostrar los 10 productos más vendidos en la historia y también los 10 productos menos
vendidos en la historia. Además mostrar de esos productos, quien fue el cliente que
mayor compra realizo.*/

select from FA



ELECT
	prod_codigo,
	(
		SELECT TOP 1 fact_cliente FROM Factura
		JOIN Item_Factura on item_numero = fact_numero and item_sucursal = fact_sucursal and item_tipo = fact_tipo
		WHERE item_producto = prod_codigo
		GROUP BY fact_cliente
		ORDER BY SUM(item_cantidad) DESC
	) clie_mas_compro
FROM Producto
WHERE prod_codigo IN 
	(
		SELECT TOP 10 item_producto FROM Item_Factura
		GROUP BY item_producto
		ORDER BY SUM(item_cantidad) DESC
	) OR
	prod_codigo IN 
	(
		SELECT TOP 10 item_producto FROM Item_Factura
		GROUP BY item_producto
		ORDER BY SUM(item_cantidad) ASC
	)


