/* 6. Mostrar para todos los rubros de artículos código, detalle, cantidad de artículos de ese
rubro y stock total de ese rubro de artículos. Solo tener en cuenta aquellos artículos que
tengan un stock mayor al del artículo ‘00000000’ en el depósito ‘00’.*/


/*aca tengo la cantidad de productos por rubro.*/
SELECT R.rubr_id,
       R.rubr_detalle,
       COUNT(P.prod_rubro) AS cantidad_articulos_rubro

 FROM Rubro R
JOIN Producto P ON P.prod_rubro = R.rubr_id
GROUP BY R.rubr_id,
         R.rubr_detalle




/* Solo tener en cuenta aquellos artículos que tengan un stock mayor al del artículo ‘00000000’ en el depósito ‘00’.*/
select ST.stoc_cantidad from STOCK ST where ST.stoc_producto = '00000000' AND ST.stoc_deposito = '00'














/* 6. Mostrar para todos los rubros de artículos 
código,
 detalle, 
 cantidad de artículos de ese rubro 
y stock total de ese rubro de artículos. 

Solo tener en cuenta aquellos artículos que tengan un stock mayor al del artículo ‘00000000’ en el depósito ‘00’.*/

select ST.stoc_cantidad from STOCK ST where ST.stoc_producto = '00000000' AND ST.stoc_deposito = '00'


SELECT R.rubr_id,
       R.rubr_detalle,
       COUNT(P.prod_rubro) AS cantidad_articulos_rubro,
	   SUM(S.stoc_cantidad) AS stock_total_rubro
FROM Rubro R
JOIN Producto P ON P.prod_rubro = R.rubr_id
JOIN STOCK S ON S.stoc_producto = P.prod_codigo
WHERE S.stoc_cantidad >  (select ST.stoc_cantidad from STOCK ST where ST.stoc_producto = '00000000' AND ST.stoc_deposito = '00')
GROUP BY R.rubr_id,
         R.rubr_detalle
ORDER BY R.rubr_id , SUM(S.stoc_cantidad) ASC

------------------------------------------------------------------------------------------------------------------------
 SELECT  R.rubr_id, R.rubr_detalle,
        COUNT(DISTINCT ISNULL(P.prod_codigo,0)) as cantidad, 
        SUM(ISNULL(S.stoc_cantidad,0)) as stock
FROM Rubro R
LEFT JOIN Producto P ON P.prod_rubro = R.rubr_id
LEFT JOIN Stock S ON S.stoc_producto = P.prod_codigo
WHERE S.stoc_deposito > (
        SELECT S2.stoc_deposito
        FROM Stock S2
        WHERE S2.stoc_producto = '00000000'
        AND S2.stoc_deposito = '00'
        )
GROUP BY R.rubr_id, R.rubr_detalle
ORDER BY R.rubr_id ASC


SELECT COUNT(ISNULL(S.stoc_cantidad,0)),S.stoc_cantidad 
FROM STOCK S 
GROUP BY S.stoc_cantidad
