/*1. Se solicita estadística por Año y familia, para ello se deberá mostrar.
Año, Código de familia, Detalle de familia, cantidad de facturas, cantidad
de productos con COmposición vendidOs, monto total vendido.
 Solo se deberán considerar las familias que tengan al menos un producto con
composición y que se hayan vendido conjuntamente (en la misma factura)
con otra familia distinta.
NOTA: No se permite el uso de sub-selects en el FROM ni funciones
definidas por el usuario para este punto,*/

-- propuesta de solucion de alguna persona...

SELECT year(f.fact_fecha),fa.fami_id,fa.fami_detalle [ANIO]
,COUNT(distinct f.fact_numero+f.fact_sucursal+f.fact_tipo) [CANTIDAD DE FACTURAS]
,(SELECT SUM(i1.item_cantidad) FROM Composicion c1
join Item_Factura i1 on i1.item_producto = c1.comp_producto
join Producto p1 on p1.prod_codigo = i1.item_producto
join Factura f1 on f1.fact_numero+f1.fact_sucursal+f1.fact_tipo=i1.item_numero+i1.item_sucursal+i1.item_tipo
where p1.prod_familia =fa.fami_id and year(f1.fact_fecha) =YEAR(f.fact_fecha ))[CANTIDAD DE PROD COMPOSICION VENDIDOS]
,SUM(i.item_cantidad*i.item_precio) [MONTO TOTAL]
FROM Factura f
join Item_Factura i on f.fact_numero+f.fact_sucursal+f.fact_tipo=i.item_numero+i.item_sucursal+i.item_tipo
join Producto p on p.prod_codigo = i.item_producto
join Familia fa on fa.fami_id = p.prod_familia
where fa.fami_id in 
(select fa1.fami_id from Composicion c1
join Producto p1 on p1.prod_codigo = c1.comp_producto
join Familia fa1 on fa1.fami_id = p1.prod_familia
join Item_Factura i1 on i1.item_producto=p1.prod_codigo
join Factura f1 on f1.fact_numero+f1.fact_sucursal+f1.fact_tipo=i1.item_numero+i1.item_sucursal+i1.item_tipo
group by fa1.fami_id)
and fa.fami_id in 
(select p1.prod_familia from Producto p1 
join Item_Factura i1 on i1.item_producto = p1.prod_codigo
join Item_Factura i2 on i1.item_numero+i1.item_sucursal+i1.item_tipo = i2.item_numero+i2.item_sucursal+i2.item_tipo
join Producto p2 on p2.prod_codigo = i2.item_producto
where p2.prod_familia <> p1.prod_familia
group by p1.prod_familia)
group by year(f.fact_fecha),fa.fami_id,fa.fami_detalle
