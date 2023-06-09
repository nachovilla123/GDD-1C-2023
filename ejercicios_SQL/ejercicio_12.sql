/*Mostrar nombre de producto, cantidad de clientes distintos que lo compraron importe
promedio pagado por el producto, 
Cantidad de depósitos en los cuales hay stock del producto y stock actual del 
producto en todos los depósitos. 

Se deberán mostrar aquellos productos que hayan tenido operaciones en el año 2012 y 
Los datos deberán ordenarse de mayor a menor por monto vendido del producto. 
*/

SELECT 
    P.prod_detalle,
    COUNT(DISTINCT F.fact_cliente) as [Clientes Totales],
    AVG(IT.item_precio * IT.item_cantidad) as [Importe Total],
(select Count(S.stoc_deposito) from STOCK S WHERE S.stoc_producto = P.prod_codigo ) AS [CANTIDAD DEPOSITOS STOCK PRODUCTO],
(select SUM(S2.stoc_cantidad) from STOCK S2 WHERE S2.stoc_producto = P.prod_codigo ) AS [STOCK TOTAL TODOS DEPOSITOS]
FROM Producto P 
JOIN Item_Factura IT ON 
    
INNER JOIN Factura F ON
    F.fact_tipo = IT.item_tipo AND F.fact_sucursal = it.item_sucursal AND IT.item_numero = F.fact_numero
GROUP BY 
    P.prod_detalle,
    P.prod_codigo
order by p.prod_codigo ASC