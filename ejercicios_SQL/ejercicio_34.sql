/*
Escriba una consulta sql que retorne para todos los rubros la cantidad de facturas mal
facturadas por cada mes del año 2011 
Se considera que una factura es incorrecta cuando
en la misma factura se factutan productos de dos rubros diferentes. Si no hay facturas

mal hechas se debe retornar 0. Las columnas que se deben mostrar son:
    1- Codigo de Rubro
    2- Mes
    3- Cantidad de facturas mal realizadas.
*/


select
	MONTH(F.fact_fecha) AS MES_DEL_2011,
	P.prod_rubro AS CODIGO_RUBRO,
	R.rubr_detalle AS DETALLE_RUBRO,
	(
		SELECT COUNT(P2.prod_rubro) FROM Factura F2 JOIN Item_Factura I2 ON F2.fact_tipo+F2.fact_sucursal+F2.fact_numero = I2.item_tipo+I2.item_sucursal+I2.item_numero
		LEFT JOIN Producto P2 ON P2.prod_codigo = I2.item_producto
		WHERE YEAR(F2.fact_fecha) = 2011 AND
			  MONTH(F2.fact_fecha) = MONTH(F.fact_fecha) AND
			  F2.fact_tipo+F2.fact_sucursal+F2.fact_numero = F.fact_tipo+F.fact_sucursal+F.fact_numero AND
			  P2.prod_rubro <> P.prod_rubro
			  group by MONTH(F2.fact_fecha), F2.fact_tipo,F2.fact_sucursal,F2.fact_numero,P2.prod_rubro
	)
from Factura F 
	JOIN Item_Factura I ON F.fact_tipo+F.fact_sucursal+F.fact_numero = I.item_tipo+I.item_sucursal+I.item_numero
	LEFT JOIN Producto P ON P.prod_codigo = I.item_producto
	LEFT JOIN Rubro R ON R.rubr_id = P.prod_rubro
	WHERE YEAR(F.fact_fecha) = 2011
group by MONTH(F.fact_fecha),P.prod_rubro,R.rubr_detalle,F.fact_tipo,F.fact_sucursal,F.fact_numero
ORDER BY  P.prod_rubro,MONTH(F.fact_fecha)






-------------------------- version de borda

