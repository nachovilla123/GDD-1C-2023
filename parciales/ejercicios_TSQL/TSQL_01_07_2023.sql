
/* --NOTA:8 : sin comentarios del profesor

2. Implementar una regla de negocio para mantener siempre consistente
(actualizada bajo cualquier circunstancia) INSERT UPDATE DELETE

una nueva tabla llamada PRODUCTOS_VENDIDOS. 
En esta tabla debe registrar el periodo (YYYYMM),
 el código de producto,
  el precio máximo de venta 
  y las unidades vendidas. 
  
  Toda esta información debe estar por periodo (YYYYMM).*/



  --Ejercicio 2

create table PRODUCTOS_VENDIDOS (periodo char(6), producto char(8), precioMaximoDeVenta decimal(12,2), unidadesVendidas decimal(12,2) )

alter procedure completarProductosVendidos
as
begin

	insert into PRODUCTOS_VENDIDOS
	select CONCAT(year(fac.fact_fecha),month(fac.fact_fecha)), i.item_producto, max(i.item_precio), sum(i.item_cantidad) 
	from Item_Factura i join Factura fac on fac.fact_tipo+fac.fact_sucursal+fac.fact_numero = i.item_tipo+i.item_sucursal+i.item_numero
	group by CONCAT(year(fac.fact_fecha),month(fac.fact_fecha)), i.item_producto

end--procedure


alter trigger actualizarProductosVendidosSegunItems
on Item_Factura 
after insert, update
as
begin

	declare @periodo char(6), @producto char(8), @preciomax decimal(12,2), @cantidad decimal(12,2)
	declare micursor cursor for 
	select 
			CONCAT(year(fac.fact_fecha),month(fac.fact_fecha)), 
			i.item_producto, 
			max(i.item_precio),
			sum(i.item_cantidad) 
		from inserted i join Factura fac on fac.fact_tipo+fac.fact_sucursal+fac.fact_numero = i.item_tipo+i.item_sucursal+i.item_numero
		group by CONCAT(year(fac.fact_fecha),month(fac.fact_fecha)), i.item_producto

	open micursor
	fetch micursor into @periodo, @producto, @preciomax, @cantidad

	while @@FETCH_STATUS = 0
	begin
		if not exists (select 1 from PRODUCTOS_VENDIDOS pv 
				       where @periodo = pv.periodo and @producto = pv.producto  ) 
		begin-- si no existe un registro para este producto y este periodo
			insert into PRODUCTOS_VENDIDOS values ( @periodo, @producto, @preciomax, @cantidad )
		end--
		else
		begin
			update PRODUCTOS_VENDIDOS
			set unidadesVendidas = unidadesVendidas + @cantidad,
			    precioMaximoDeVenta = case when (@preciomax > precioMaximoDeVenta) then @preciomax else precioMaximoDeVenta end 
			where producto = @producto and periodo = @periodo

		end-- si ya existe el registro para ese producto y ese periodo
		fetch micursor into @periodo, @producto, @preciomax, @cantidad
	end--cursor
	close micursor
	deallocate micursor
end--trigger



/* 
Se realiza un procedure que va a insertar en nuestra nueva tabla toda la informacion almacenada en Item_Factura hasta el momento,
y se crea un trigger que va a seguir insertando datos en la tabla nueva cada vez que se inserte algo nuevo en Item_Factura verificando si ya existe un registro para cada
producto y periodo insertado, si ya existe lo actualiza. Si no existe, lo inserta.
*/