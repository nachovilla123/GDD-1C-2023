
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








/*10. Mostrar los 10 productos más vendidos en la historia y también los 10 productos menos
vendidos en la historia. Además mostrar de esos productos, quien fue el cliente que
mayor compra realizo.*/


SELECT CODIGO_PROD_, DETALLE_PROD1, CantidadVendidaProducto
FROM (
    SELECT TOP 10 
        P1.prod_codigo AS CODIGO_PROD_,
        P1.prod_detalle AS DETALLE_PROD1,
        SUM(I1.item_cantidad) AS CantidadVendidaProducto
    FROM Factura F 
        JOIN Item_Factura I1 ON I1.item_tipo = F.fact_tipo AND
                               I1.item_sucursal = F.fact_sucursal AND
                               I1.item_numero = F.fact_numero
        JOIN Producto P1 ON P1.prod_codigo = I1.item_producto
    GROUP BY P1.prod_codigo ,
             P1.prod_detalle
    ORDER BY SUM(I1.item_cantidad) ASC
) AS t1

UNION ALL

SELECT CODIGO_PROD_, DETALLE_PROD1, CantidadVendidaProducto
FROM (
    SELECT TOP 10 
        P1.prod_codigo AS CODIGO_PROD_,
        P1.prod_detalle AS DETALLE_PROD1,
        SUM(I1.item_cantidad) AS CantidadVendidaProducto
    FROM Factura F 
        JOIN Item_Factura I1 ON I1.item_tipo = F.fact_tipo AND
                               I1.item_sucursal = F.fact_sucursal AND
                               I1.item_numero = F.fact_numero
        JOIN Producto P1 ON P1.prod_codigo = I1.item_producto
    GROUP BY P1.prod_codigo ,
             P1.prod_detalle
    ORDER BY SUM(I1.item_cantidad) DESC
) AS t2