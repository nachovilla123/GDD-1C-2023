/*
26. Escriba una consulta sql que retorne un ranking de empleados devolviendo las
siguientes columnas:
 Empleado
 Depósitos que tiene a cargo
 Monto total facturado en el año corriente
 Codigo de Cliente al que mas le vendió
 Producto más vendido
 Porcentaje de la venta de ese empleado sobre el total vendido ese año.
Los datos deberan ser ordenados por venta del empleado de mayor a menor.
*/

select
	E.empl_codigo,
	Count(D.depo_encargado) as Depositos_a_cargo,
	Sum(ISNULL( F.fact_total,0)) as Total_Facturado_anio_corriente,
	(
		Select top 1  F2.fact_cliente from Factura F2 
		Where Year(F2.fact_fecha) = 2012 AND F2.fact_vendedor = E.empl_codigo
		Group by F2.fact_cliente
		order by Count(F2.fact_cliente) DESC
	) as [Codigo de Cliente al que mas le vendió],
	(
		Select top 1  I3.item_producto from Factura F3 
		Join Item_Factura I3 On F3.fact_tipo+F3.fact_sucursal+F3.fact_numero = I3.item_tipo+I3.item_sucursal+I3.item_numero
		Where Year(F3.fact_fecha) = 2012 AND F3.fact_vendedor = E.empl_codigo
		Group by I3.item_producto
		order by SUM(I3.item_cantidad) DESC
		
	) as Producto_Mas_vendido ,
	((Sum(ISNULL( F.fact_total,0)) ) / (
												Select Sum(ISNULL( F5.fact_total,0)) from Factura F5
												Where Year(F5.fact_fecha) = 2012 
												) * 100
	) as porcentajeVentaEmpleado
	

from Empleado E Left Join DEPOSITO D ON D.depo_encargado = E.empl_codigo
Left Join Factura F ON F.fact_vendedor = E.empl_codigo AND Year(F.fact_fecha) = 2012



group by E.empl_codigo,D.depo_encargado
order by E.empl_codigo

