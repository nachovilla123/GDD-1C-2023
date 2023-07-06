/*
--------------------------- PARCIAL 28/07/2023 ---------------------------
1) 
Realizar una consulta SQL que devuelva todos los clientes que durante
2 años consecutivos compraron al menos 5 productos distintos. 

De esos clientes mostrar:
• El codigo de cliente
• El monto total comprado en el 2012
• La cantidad de unidades de productos compradas en el 2012

El resultado debe ser ordenado primero por aquellos clientes que compraron
solo productos compuestos en algun momento, luego el resto.

Nota: No se permiten select en el from, es decir, select from (select ...) as T ...
*/

SELECT
	F.fact_cliente as Cliente,
	SUM(F.fact_total) as [Monto Total 2012],
	SUM(DISTINCT IT.item_cantidad) as [Unidades Compradas 2012]
FROM Factura F
	INNER JOIN Item_Factura IT ON
		F.fact_numero + F.fact_sucursal + F.fact_numero = IT.item_numero + IT.item_sucursal + IT.item_numero
	WHERE YEAR(F.fact_fecha) = 2012
	GROUP BY F.fact_cliente
	HAVING
		(
			SELECT TOP 1 COUNT(DISTINCT IT2.item_producto) + COUNT(DISTINCT IT3.item_producto) 
			FROM Factura F2 
				INNER JOIN Item_Factura IT2 ON
					F2.fact_numero + F2.fact_sucursal + F2.fact_numero = IT2.item_numero + IT2.item_sucursal + IT2.item_numero
				INNER JOIN Factura F3 ON
					F3.fact_cliente = F2.fact_cliente
				INNER JOIN Item_Factura IT3 ON
					F3.fact_numero + F3.fact_sucursal + F3.fact_numero = IT3.item_numero + IT3.item_sucursal + IT3.item_numero
			WHERE F2.fact_cliente = F.fact_cliente AND (DATEDIFF(YEAR,F2.fact_fecha,F3.fact_fecha) = 1) AND IT3.item_producto != IT2.item_producto
			GROUP BY YEAR(F2.fact_fecha),YEAR(F3.fact_fecha)
			ORDER BY COUNT(DISTINCT IT2.item_producto) + COUNT(DISTINCT IT3.item_producto) DESC
		) > 4
	ORDER BY CASE
		WHEN 
			F.fact_cliente IN (
								SELECT DISTINCT F4.fact_cliente
								FROM Factura F4
									INNER JOIN Item_Factura IT4 ON
										F4.fact_numero + F4.fact_sucursal + F4.fact_numero = IT4.item_numero + IT4.item_sucursal + IT4.item_numero
									INNER JOIN Composicion C ON
										IT4.item_producto = C.comp_producto
								)
		THEN 1
		ELSE 2
		END ASC