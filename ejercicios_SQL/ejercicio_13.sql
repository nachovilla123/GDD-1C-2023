/*
13. Realizar una consulta que retorne para cada producto que posea composición 
nombredel producto, 
precio del producto, 
precio de la sumatoria de los precios por la cantidad de los productos que lo componen. 

Solo se deberán mostrar los productos que estén compuestos por más de 2 productos 

y deben ser ordenados de mayor a menor por cantidad de productos que lo componen.
*/

select P1.prod_detalle AS [DETALLE COMPOSICION],
	   P1.prod_precio AS [PRECIO COMPOSICION],
	   SUM(C.comp_cantidad * P2.prod_precio) AS [PRECIO SUMATORIA]
from Composicion C 
JOIN Producto P1 ON P1.prod_codigo = C.comp_producto
JOIN Producto P2 ON P2.prod_codigo = C.comp_componente
GROUP BY P1.prod_detalle,P1.prod_precio

-- ME FALTA QUE ESTEN COMPUESTOS POR MAS DE 2 PRODUCTOS
ORDER BY COUNT(C.comp_componente) ASC