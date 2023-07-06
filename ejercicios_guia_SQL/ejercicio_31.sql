/*
31. Escriba una consulta sql que retorne una estadística por Año y Vendedor que retorne las
siguientes columnas:
 Año.
 Codigo de Vendedor
 Detalle del Vendedor
 Cantidad de facturas que realizó en ese año
 Cantidad de clientes a los cuales les vendió en ese año.
 Cantidad de productos facturados con composición en ese año
 Cantidad de productos facturados sin composicion en ese año.
 Monto total vendido por ese vendedor en ese año
Los datos deberan ser ordenados por año y dentro del año por el vendedor que haya
vendido mas productos diferentes de mayor a menor.
*/

SELECT 
	YEAR(F.fact_fecha) as ANIO,
	E.empl_codigo as Codigo_vendedor,
	E.empl_nombre as Nombre_vendedor,
	E.empl_apellido as Apellido_vendedor,
	(   --
		SELECT COUNT(E2.empl_codigo) FROM Factura F2 LEFT JOIN Empleado E2 ON F2.fact_vendedor = E2.empl_codigo 
		WHERE E2.empl_codigo = E.empl_codigo AND Year(F2.fact_fecha) = Year(F.fact_fecha)
		GROUP BY Year(F2.fact_fecha), E2.empl_nombre , E2.empl_apellido -- es necesario?
	) AS CANT_FACTURAS_ANIO
	
FROM Factura F 
LEFT JOIN Empleado E ON F.fact_vendedor = E.empl_codigo 
GROUP BY  Year(F.fact_fecha), E.empl_nombre , E.empl_apellido,E.empl_codigo
ORDER BY Year(F.fact_fecha)