-- nota:8 sin comentarios

/* Se pide que realice un reporte generado por una sola query que de cortes de informacion por periodos
(anual,semestral y bimestral). Un corte por el año, un corte por el semestre el año y un corte por bimestre el año. 
En el corte por año mostrar las ventas totales realizadas por año, la cantidad de rubros distintos comprados por año, 
la cantidad de productos con composicion distintos comporados por año y la cantidad de clientes que compraron por año.
Luego, en la informacion del semestre mostrar la misma informacion, es decir, las ventas totales por semestre, cantidad de rubros 
por semestre, etc. y la misma logica por bimestre. El orden tiene que ser cronologico.

*/

SELECT CONCAT(YEAR(f1.fact_fecha), '') AS 'Periodo', SUM(f1.fact_total) AS 'Ventas totales',

(SELECT COUNT(DISTINCT prod_rubro) FROM Item_Factura
JOIN Producto ON prod_codigo = item_producto
JOIN Factura f2 ON f2.fact_numero = item_numero AND f2.fact_sucursal = item_sucursal AND f2.fact_tipo = item_tipo
WHERE YEAR(F2.fact_fecha) = YEAR(f1.fact_fecha)) AS 'Cant rubros',

(SELECT COUNT(DISTINCT prod_codigo) FROM Item_Factura 
JOIN Producto ON prod_codigo = item_producto
JOIN Composicion ON comp_producto = prod_codigo
JOIN Factura f2 ON f2.fact_numero = item_numero AND f2.fact_sucursal = item_sucursal AND f2.fact_tipo = item_tipo
WHERE YEAR(F2.fact_fecha) = YEAR(f1.fact_fecha)) AS 'Cant productos compuestos',

COUNT(f1.fact_cliente) AS 'Clientes del año'

FROM Factura f1
GROUP BY YEAR(f1.fact_fecha)

UNION 

SELECT CONCAT('Semestre ',(case when(MONTH(f1.fact_fecha) <=6) then 0 else 1 end)), SUM(f1.fact_total) AS 'Ventas totales',

(SELECT COUNT(DISTINCT prod_rubro) FROM Item_Factura
JOIN Producto ON prod_codigo = item_producto
JOIN Factura f2 ON f2.fact_numero = item_numero AND f2.fact_sucursal = item_sucursal AND f2.fact_tipo = item_tipo
WHERE YEAR(F2.fact_fecha) = YEAR(f1.fact_fecha)) AS 'Cant rubros',

(SELECT COUNT(DISTINCT prod_codigo) FROM Item_Factura 
JOIN Producto ON prod_codigo = item_producto
JOIN Composicion ON comp_producto = prod_codigo
JOIN Factura f2 ON f2.fact_numero = item_numero AND f2.fact_sucursal = item_sucursal AND f2.fact_tipo = item_tipo
WHERE YEAR(F2.fact_fecha) = YEAR(f1.fact_fecha)) AS 'Cant productos compuestos',

COUNT(f1.fact_cliente) AS 'Clientes del año'

FROM Factura f1
GROUP BY YEAR(f1.fact_fecha), (case when(MONTH(f1.fact_fecha) <=6) then 0 else 1 end)

UNION 

SELECT CONCAT('Bimestre ',(FLOOR((MONTH(f1.fact_fecha)-1)/2) + 1)), SUM(f1.fact_total) AS 'Ventas totales',

(SELECT COUNT(DISTINCT prod_rubro) FROM Item_Factura
JOIN Producto ON prod_codigo = item_producto
JOIN Factura f2 ON f2.fact_numero = item_numero AND f2.fact_sucursal = item_sucursal AND f2.fact_tipo = item_tipo
WHERE YEAR(F2.fact_fecha) = YEAR(f1.fact_fecha)) AS 'Cant rubros',

(SELECT COUNT(DISTINCT prod_codigo) FROM Item_Factura 
JOIN Producto ON prod_codigo = item_producto
JOIN Composicion ON comp_producto = prod_codigo
JOIN Factura f2 ON f2.fact_numero = item_numero AND f2.fact_sucursal = item_sucursal AND f2.fact_tipo = item_tipo
WHERE YEAR(F2.fact_fecha) = YEAR(f1.fact_fecha)) AS 'Cant productos compuestos',

COUNT(f1.fact_cliente) AS 'Clientes del año'

FROM Factura f1
GROUP BY YEAR(f1.fact_fecha), (FLOOR((MONTH(f1.fact_fecha)-1)/2) + 1)


--PRIMERO ESTAN LOS AÑOS, LUEGO LOS BIMESTRES Y LUEGOS LOS SEMESTRES. POR CADA UNO DE ELLOS, ESTAN ORDENADOS CRONOLOGICAMENTE.