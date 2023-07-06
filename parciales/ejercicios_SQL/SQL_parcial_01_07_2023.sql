/* nota:7 sin comentarios del profesor.
1. Realizar una consulta SQL que muestre aquellos clientes que en 2
años consecutivos compraron.
De estos clientes mostrar
	█iEl código de cliente.
	█iii.El nombre del cliente.
	█iv.El numero de rubros que compro el cliente.
	█La cantidad de productos con composición que compro el cliente en el 2012.

█El resultado deberá ser ordenado por cantidad de facturas del cliente en toda la historia, de manera ascendente.

Nota: No se permiten select en el from, es decir, select ... from (select ...) as T,
*/



SELECT 
	CL.clie_codigo,
	CL.clie_razon_social as nombre_cliente,
	COUNT(DISTINCT P.prod_rubro) AS [numero de rubros que compro el cliente],
	(
		SELECT	COUNT (DISTINCT C1.comp_producto)
		FROM Factura F2
			INNER JOIN Item_Factura I2
				ON F2.fact_tipo+F2.fact_sucursal+F2.fact_numero=I2.item_tipo+I2.item_sucursal+I2.item_numero
			 INNER JOIN Composicion C1
				ON C1.comp_producto = I2.item_producto
		WHERE YEAR(F2.fact_fecha) = 2012 AND F2.fact_cliente = CL.clie_codigo
	) AS [La cantidad de productos con composición que compro el cliente en el 2012]
	
FROM Cliente CL 
	INNER JOIN Factura F 
		ON F.fact_cliente = CL.clie_codigo
	INNER JOIN Item_Factura I 
		ON F.fact_tipo+F.fact_sucursal+F.fact_numero=I.item_tipo+I.item_sucursal+I.item_numero
	JOIN Producto P 
		ON P.prod_codigo = I.item_producto

WHERE	0 < ( 
				SELECT 
					COUNT(DISTINCT I5.item_producto)
				FROM Item_Factura I5
				INNER JOIN Factura F5 ON F5.fact_numero = I5.item_numero AND F5.fact_sucursal = I5.item_sucursal AND F5.fact_tipo = I5.item_tipo
				WHERE YEAR(F5.fact_fecha) = YEAR(f.fact_fecha) AND F5.fact_cliente = CL.clie_codigo
			 ) AND
		0 < (
				SELECT 
					COUNT(DISTINCT I6.item_producto)
				FROM Item_Factura I6
				INNER JOIN Factura F6 ON F6.fact_numero = I6.item_numero AND F6.fact_sucursal = I6.item_sucursal AND F6.fact_tipo = I6.item_tipo
				WHERE YEAR(F6.fact_fecha) = YEAR(f.fact_fecha) + 1 AND F6.fact_cliente = CL.clie_codigo
			 )

GROUP BY CL.clie_codigo,CL.clie_razon_social

ORDER BY COUNT(DISTINCT F.fact_tipo+F.fact_sucursal+F.fact_numero) ASC




--------------------
-- 2da version: NOTA: 8 : sin comentarios del profesor
-----------


--Ejercicio 1. 
select 
	c.clie_codigo codigoCliente,
	c.clie_razon_social nombreCliente,
	count(distinct p.prod_rubro) cantidadRubros,
	isnull((select sum(ifa.item_cantidad) from Item_Factura ifa join Factura fact on ifa.item_tipo=fact.fact_tipo and ifa.item_sucursal= fact.fact_sucursal and ifa.item_numero = fact.fact_numero 
	 join Composicion on comp_producto = ifa.item_producto
	 where YEAR(fact.fact_fecha) = 2012 and fact.fact_cliente = c.clie_codigo ),0) productosCompuestosCompradosEn2012 
from Cliente c join Factura f on f.fact_cliente = c.clie_codigo
join Item_Factura i on f.fact_tipo= i.item_tipo and f.fact_sucursal = i.item_sucursal and f.fact_numero = i.item_numero 
join Producto p on p.prod_codigo = i.item_producto
where exists 
(select 1 from Item_Factura it
inner join Factura f2 on f2.fact_numero = it.item_numero and f2.fact_sucursal = it.item_sucursal and f2.fact_tipo = it.item_tipo
where YEAR(f2.fact_fecha) = YEAR(f.fact_fecha) and f2.fact_cliente = c.clie_codigo ) and 
exists
(select 1 from  Item_Factura it2
inner join Factura f3 on f3.fact_numero = it2.item_numero and f3.fact_sucursal = it2.item_sucursal and f3.fact_tipo = it2.item_tipo
where YEAR(f3.fact_fecha) = YEAR(f.fact_fecha) + 1 and f3.fact_cliente = c.clie_codigo ) 
group by c.clie_codigo, c.clie_razon_social
order by count(distinct f.fact_tipo+f.fact_sucursal+f.fact_numero) asc


/* 
se asumió que al decir "cantidad de productos con composicion" se refiere a sumatoria de unidades de productos con composicion que el cliente
compro en 2012, si en cambio fuera cantidad de productos compuestos distintos que compro en 2012 en la linea 5 seria count(distinct(comp_producto))
en lugar de sum(item_cantidad)
*/ 

