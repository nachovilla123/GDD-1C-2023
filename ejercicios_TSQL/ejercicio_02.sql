/*
2. Realizar una función que dado un artículo y una fecha, retorne el stock que
existía a esa fecha
*/

alter function ej2 (@articulo char(8), @fecha date) 
returns decimal(12,2)
as 
begin
RETURN 
(
Select Sum(I1.item_cantidad)
from Factura F  JOIN Item_Factura I1 
	ON I1.item_tipo = F.fact_tipo AND
       I1.item_sucursal = F.fact_sucursal AND
	   I1.item_numero = F.fact_numero 
WHERE I1.item_producto = @articulo AND F.fact_fecha < @fecha
) + (SELECT SUM(S.stoc_cantidad) from STOCK S WHERE S.stoc_producto = @articulo)
								
end