
-- version de otra persona . Tiene un subselect en el from. nose si es valido.
select year(fact_fecha) AÑO,
fact_cliente [CLIENTE MAL COBRADO],
COUNT(fact_cliente) [CANT_FACTURAS]
from Factura
where fact_total - fact_total_impuestos - (select SUM(item_cantidad*item_precio) 
											   from Item_Factura
											   where fact_numero+fact_tipo+fact_sucursal = 
											   item_numero+item_tipo+item_sucursal) > 1
group by YEAR(fact_fecha), fact_cliente
order by 1 asc, 2 asc, 3 desc

------------------------------------------------- encarando por otro lado

-- FACTURAS QUE ESTAN MAL
SELECT FM.item_tipo+FM.item_sucursal+FM.item_numero FROM Item_Factura FM
group by FM.item_tipo+FM.item_sucursal+FM.item_numero
having sum(FM.item_precio*FM.item_cantidad) <> (select FMH.fact_total-FMH.fact_total_impuestos from Factura FMH 
where FMH.fact_tipo+FMH.fact_sucursal+FMH.fact_numero = FM.item_tipo+FM.item_sucursal+FM.item_numero)

-- ej encarado :
select 
	Year(F1.fact_fecha) as ANIO,
	(
		SELECT COUNT(DISTINCT F2.fact_cliente) 
		FROM Factura F2 
		WHERE F2.fact_tipo+F2.fact_sucursal+F2.fact_numero IN (
			SELECT FM.item_tipo+FM.item_sucursal+FM.item_numero FROM Item_Factura FM
			group by FM.item_tipo+FM.item_sucursal+FM.item_numero
			having sum(FM.item_precio*FM.item_cantidad) <> (select FMH.fact_total-FMH.fact_total_impuestos from Factura FMH 
			where FMH.fact_tipo+FMH.fact_sucursal+FMH.fact_numero = FM.item_tipo+FM.item_sucursal+FM.item_numero)
		)
	) AS CLIENTES_MAL_FACTURADOS

FROM Factura F1 
GROUP BY Year(F1.fact_fecha)