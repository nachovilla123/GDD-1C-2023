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