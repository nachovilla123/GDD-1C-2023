create PROCEDURE SP_UNIFICAR_PRODUCTO
AS
BEGIN
	declare @combo char(8);
	declare @combocantidad integer;
	
	declare @fact_tipo char(1);
	declare @fact_suc char(4);
	declare @fact_nro char(8);
	
	
	
	declare  cFacturas cursor for --CURSOR PARA RECORRER LAS FACTURAS
		select fact_tipo, fact_sucursal, fact_numero
		from Factura ;
		/* where para hacer una prueba acotada
		where fact_tipo = 'A' and
				fact_sucursal = '0003' and
				fact_numero='00092476'; */
		
		open cFacturas
		
		fetch next from cFacturas
		into @fact_tipo, @fact_suc, @fact_nro
		
		while @@FETCH_STATUS = 0
		begin	
			declare  cProducto cursor for
			select comp_producto --ACA NECESITAMOS UN CURSOR PORQUE PUEDE HABER MAS DE UN COMBO EN UNA FACTURA
			from Item_Factura join Composicion C1 on (item_producto = C1.comp_componente)
			where item_cantidad >= C1.comp_cantidad and
				  item_sucursal = @fact_suc and
				  item_numero = @fact_nro and
				  item_tipo = @fact_tipo
			group by C1.comp_producto
			having COUNT(*) = (select COUNT(*) from Composicion as C2 where C2.comp_producto= C1.comp_producto)
			
			open cProducto
			fetch next from cProducto into @combo
			while @@FETCH_STATUS = 0 
			begin
	  					
				select @combocantidad= MIN(FLOOR((item_cantidad/c1.comp_cantidad)))
				from Item_Factura join Composicion C1 on (item_producto = C1.comp_componente)
				where item_cantidad >= C1.comp_cantidad and
					  item_sucursal = @fact_suc and
					  item_numero = @fact_nro and
					  item_tipo = @fact_tipo and
					  c1.comp_producto = @combo	--SACAMOS CUANTOS COMBOS PUEDO ARMAR COMO MÁXIMO (POR ESO EL MIN)
				
				--INSERTAMOS LA FILA DEL COMBO CON EL PRECIO QUE CORRESPONDE
				insert into Item_Factura (item_tipo, item_sucursal, item_numero, item_producto, item_cantidad, item_precio)
				select @fact_tipo, @fact_suc, @fact_nro, @combo, @combocantidad, (@combocantidad * (select prod_precio from Producto where prod_codigo = @combo));				

				update Item_Factura  
				set 
				item_cantidad = i1.item_cantidad - (@combocantidad * (select comp_cantidad from Composicion
																		where i1.item_producto = comp_componente 
																			  and comp_producto=@combo)),
				ITEM_PRECIO = (i1.item_cantidad - (@combocantidad * (select comp_cantidad from Composicion
															where i1.item_producto = comp_componente 
																  and comp_producto=@combo))) * 	
													(select prod_precio from Producto where prod_codigo = I1.item_producto)											  															  
				from Item_Factura I1, Composicion C1 
				where I1.item_sucursal = @fact_suc and
					  I1.item_numero = @fact_nro and
					  I1.item_tipo = @fact_tipo AND
					  I1.item_producto = C1.comp_componente AND
					  C1.comp_producto = @combo
					  
				delete from Item_Factura
				where item_sucursal = @fact_suc and
					  item_numero = @fact_nro and
					  item_tipo = @fact_tipo and
					  item_cantidad = 0
				
				fetch next from cproducto into @combo
			end
			close cProducto;
			deallocate cProducto;
			
			fetch next from cFacturas into @fact_tipo, @fact_suc, @fact_nro
			end
			close cFacturas;
			deallocate cFacturas;
	end 
		
					
						
				  
		