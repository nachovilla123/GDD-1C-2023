


/* solucion del profe

8. Mostrar para el o los artículos que tengan stock en todos los depósitos, nombre del
artículo, stock del depósito que más stock tiene.
*/
SELECT
 p.prod_detalle,
 max(s.stoc_cantidad) max_stock
FROM Producto p
JOIN STOCK s
 ON p.prod_codigo = s.stoc_producto
 AND s.stoc_cantidad > 0
GROUP BY
 p.prod_detalle
HAVING
 count(s.stoc_deposito) = (select count(*) FROM DEPOSITO d)
