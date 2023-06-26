alter function FN_CALCULAR_CANT_EMPLEADOS (@empleado numeric(6,0))
returns int
as
	begin
		declare @cantidad int
		declare @emp_jefe numeric(6,0)
		declare @emp_codigo numeric(6,0)
				
		set @cantidad = 0;
				
		if NOT EXISTS(SELECT * FROM Empleado WHERE @empleado = empl_jefe)
		begin
			RETURN @cantidad
		end;		
				
		set @cantidad = (select count(*) from empleado where empl_jefe=@empleado and empl_codigo>@empleado)
		
		declare cEmp cursor for
		select empl_jefe, empl_codigo
		from Empleado 
		where empl_jefe = @empleado
		
		open cEmp
		fetch next from cEmp into @emp_jefe, @emp_codigo
		while @@FETCH_STATUS = 0
			begin
				set @cantidad = @cantidad + dbo.FN_CALCULAR_CANT_EMPLEADOS(@emp_codigo)
				fetch next from cEmp into @emp_jefe, @emp_codigo
			end
		close cEmp;
		deallocate cEmp;	
		return @cantidad;	
	end;
	
	
