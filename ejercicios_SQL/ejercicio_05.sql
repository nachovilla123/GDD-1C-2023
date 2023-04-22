 /*
 5. Realizar una consulta que muestre código de artículo, detalle y cantidad de egresos de
stock que se realizaron para ese artículo en el año 2012 (egresan los productos que
fueron vendidos). Mostrar solo aquellos que hayan tenido más egresos que en el 2011.
 */

 select P.prod_codigo,
		P.prod_detalle,
		SUM(I.item_cantidad) AS cantidad_vendida2012
		from Factura F
		
 JOIN Item_Factura I ON I.item_tipo = F.fact_tipo AND I.item_sucursal = F.fact_sucursal AND I.item_numero = F.fact_numero
 JOIN Producto P ON P.prod_codigo = I.item_producto
 WHERE YEAR(F.fact_fecha) = 2012
 GROUP BY P.prod_codigo,
		P.prod_detalle
HAVING SUM(I.item_cantidad) >  (
		SELECT SUM(I2.item_cantidad)

		FROM FACTURA F2 
		JOIN Item_Factura I2
			ON I2.item_numero = F2.fact_numero 
            AND I2.item_sucursal =  F2.fact_sucursal 
            AND  I2.item_tipo = F2.fact_tipo 
		WHERE YEAR(F2.fact_fecha) = 2011 AND I2.item_producto = P.prod_codigo
		)
ORDER BY cantidad_vendida2012 DESC



/*version del profesor mas performante porque no tiene subselect*/
SELECT 
 p1.prod_codigo,
 p1.prod_detalle,
 SUM(
  CASE WHEN YEAR(fact_fecha) = 2012 THEN item_cantidad 
    ELSE 0 
  END 
 ) as cant_vendida
FROM Producto p1
JOIN Item_Factura i1 on i1.item_producto = p1.prod_codigo
JOIN Factura f1 
  on i1.item_numero = f1.fact_numero 
 and i1.item_sucursal = f1.fact_sucursal 
 and i1.item_tipo = f1.fact_tipo
WHERE 
 YEAR(f1.fact_fecha) IN ( 2012 , 2011 )
GROUP BY 
 p1.prod_codigo,
 p1.prod_detalle
HAVING 
  SUM(
   CASE WHEN YEAR(fact_fecha) = 2012 THEN item_cantidad 
     ELSE 0 
   END 
  ) > 
  ISNULL(SUM(
   CASE WHEN YEAR(fact_fecha) = 2011 THEN item_cantidad 
     ELSE 0 
   END 
  ),0)