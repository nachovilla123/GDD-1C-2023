/* pensar en un big mac : buger papa coca
Realizar una consulta SQL que muestre aquellos productos que 

	  █tengan 3 componentes a nivel producto y 
	  █cuyos componentes tengan 2 rubros distintos.
 
De estos productos mostrar:
	 █i.El código de producto.
	 █ii.El nombre del producto.
	 █iii.La cantidad de veces que fueron vendidos sus componentes en el 2012.
	 █iv.Monto total vendido del producto.

El resultado ser ordenado por cantidad de facturas del 2012 en las cuales se vendieron los componentes.

Nota: No se permiten select en el from, es decir, select from (select as T....
*/

SELECT
	P.prod_codigo as [Codigo de Producto],
	P.prod_detalle as [Nombre de Producto],
	ISNULL(
		(
			SELECT count(F.fact_numero + F.fact_sucursal + F.fact_tipo ) 
			FROM Item_Factura IT2 
				INNER JOIN Factura F 
					ON F.fact_numero + F.fact_sucursal + F.fact_tipo = IT2.item_numero + IT2.item_sucursal + IT2.item_tipo 
				INNER JOIN Composicion C3 
					ON C3.comp_producto = P.prod_codigo
			WHERE IT2.item_producto = C3.comp_componente AND YEAR(F.fact_fecha) = 2012
			) ,0) as [Cantidad de Componentes vendida en 2012],

	ISNULL((
		SELECT SUM(IT.item_precio + IT.item_cantidad)  
		FROM Item_Factura IT 
		WHERE IT.item_producto = P.prod_codigo
		),0 ) AS [Monto Vendido Producto]

FROM Producto P 
    INNER JOIN Composicion C 
		ON C.comp_producto = P.prod_codigo

GROUP BY P.prod_codigo,P.prod_detalle

HAVING (--cuyos componentes tengan 2 rubros distintos.
			SELECT COUNT(DISTINCT P6.prod_rubro)
			FROM Producto P6
			INNER JOIN Composicion C6 ON P6.prod_codigo = C6.comp_componente
			WHERE C6.comp_producto = P.prod_codigo
	   ) > 1
	   and
	    (
		SELECT COUNT(DISTINCT C2.comp_componente) 
		FROM Composicion C2 
		WHERE C2.comp_producto = P.prod_codigo
	   ) > 1 -- ACA VA UN 2 PORQUE EN LA BASE DE DATOS NO HAY NINGUNO DE 3 COMPONENTES.

ORDER BY (
			select count( f8.fact_numero + f8.fact_sucursal + f8.fact_tipo ) from Factura f8
				inner join Item_Factura i8
					ON f8.fact_numero + f8.fact_sucursal + f8.fact_tipo = i8.item_numero + i8.item_sucursal + i8.item_tipo
				inner join Composicion C8 
					ON C8.comp_producto = P.prod_codigo
				where i8.item_producto = C8.comp_componente 

		 ) DESC

--El resultado ser ordenado por cantidad de facturas del 2012 en las cuales se vendieron los componentes. 