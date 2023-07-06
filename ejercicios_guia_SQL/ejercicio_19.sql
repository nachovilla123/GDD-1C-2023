/*
19. En virtud de una recategorizacion de productos referida a la familia de los mismos se
solicita que desarrolle una consulta sql que retorne para todos los productos:
 Codigo de producto
 Detalle del producto
 Codigo de la familia del producto
 Detalle de la familia actual del producto
 Codigo de la familia sugerido para el producto
 Detalla de la familia sugerido para el producto

La familia sugerida para un producto es la que poseen la mayoria de los productos cuyo
detalle coinciden en los primeros 5 caracteres.

En caso que 2 o mas familias pudieran ser sugeridas se debera seleccionar la de menor codigo. 
Solo se deben mostrar los productos para los cuales la familia actual sea
diferente a la sugerida Los resultados deben ser ordenados por detalle de producto de manera ascendente
*/


SELECT 
P.prod_codigo,
P.prod_detalle,
P.prod_familia,
F.fami_detalle,
ISNULL((select top 1 fami_id 
from Familia
where substring(fami_detalle,0, 5) = SUBSTRING(prod_detalle, 0, 5)
order by prod_codigo asc), '999') FAMILIA_SUGERIDA,

ISNULL((select top 1 fami_detalle 
from Familia
where substring(fami_detalle,0, 5) = SUBSTRING(prod_detalle, 0, 5)
order by prod_codigo asc), '999') DETALLE_FLIA_SUGERIDA

FROM PRODUCTO P JOIN Familia F ON F.fami_id = P.prod_familia
where prod_familia <> ISNULL(( -----------------------------------simbolo para not equal
							select top 1 fami_id 
							from Familia
							where substring(fami_detalle,0, 5) = SUBSTRING(prod_detalle, 0, 5)
							order by prod_codigo asc), 
					'999')
order by prod_detalle asc

