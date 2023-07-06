 /*4. Realizar una consulta que muestre para todos los artículos código, detalle y cantidad de
artículos que lo componen. Mostrar solo aquellos artículos para los cuales el stock
promedio por depósito sea mayor a 100.

tengo una zapatilla, lo compone 0
combo 1 => 2 hamurguesa 1 papa

*/


SELECT
 p.prod_codigo,
 p.prod_detalle,
 ISNULL(SUM(c.comp_cantidad),0) 
FROM Producto p LEFT JOIN Composicion c
ON c.comp_producto = p.prod_codigo
 --aquellos artículos para los cuales el stock promedio por depósito sea mayor a 100.
GROUP BY 
 p.prod_codigo, 
 p.prod_detalle
HAVING  
 (SELECT AVG(s.stoc_cantidad) 
 FROM STOCK s 
 WHERE s.stoc_producto = p.prod_codigo GROUP BY s.stoc_producto) > 100