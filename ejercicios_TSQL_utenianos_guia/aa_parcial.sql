----------------------

select 
zona_detalle as 'Zona', 

count(distinct depo_codigo),

(select count(distinct comp_producto) from Composicion
join STOCK on stoc_producto = comp_producto
join DEPOSITO on depo_codigo = stoc_deposito
where z.zona_codigo = depo_zona) as 'Productos con composicion',

(select top 1 prod_codigo 
	from Producto
		join STOCK on stoc_producto = prod_codigo
		join DEPOSITO on depo_codigo = stoc_deposito
	where prod_codigo = (
						select top 1 prod_codigo
						from Item_Factura 
						join Producto 
							on prod_codigo = item_producto
						join Factura 
							on fact_numero + fact_tipo + fact_sucursal = item_numero + item_tipo + item_sucursal
						where year(fact_fecha) = 2012
						group by prod_codigo 
						order by sum(item_cantidad) desc
					)
			and z.zona_codigo = depo_zona
) as 'Producto mas vendido del 2012',

(SELECT TOP 1 fact_vendedor
FROM Factura 
WHERE fact_vendedor IN (SELECT depo_encargado FROM DEPOSITO WHERE depo_zona = z.zona_codigo)
GROUP BY fact_vendedor
ORDER BY SUM(fact_total) DESC ) as 'Mejor empleado' 

from DEPOSITO d
join Zona z on d.depo_zona = zona_codigo
group by z.zona_detalle, z.zona_codigo
having count(distinct depo_codigo) >= 3
