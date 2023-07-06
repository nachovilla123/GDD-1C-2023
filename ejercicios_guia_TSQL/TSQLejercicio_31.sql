/*
31. Desarrolle el o los objetos de base de datos necesarios, 

para que un jefe no pueda tener más de 15 empleados a cargo, directa o indirectamente, 

 si esto ocurre debera asignarsele un jefe que cumpla esa condición, 
 
 si no existe un jefe para asignarle se le deberá colocar como jefe al gerente general 
 que es aquel que no tiene jefe.
*/

alter function getEmpleadosACargo(@empleado numeric(6))
RETURNS int 
as
begin

	DECLARE @empleadosACargoDirectos int = 0 , @empleadosACargoIndirectos int = 0,  @subEmpleado numeric(6)
	
	set @empleadosACargoDirectos = ( Select Isnull(Count(DISTINCT E1.empl_codigo),0) 
									from Empleado E1 
									Where E1.empl_jefe = @empleado)

	DECLARE cursor_subempleados CURSOR
		FOR SELECT
			E3.empl_codigo
			FROM Empleado E3 
			WHERE E3.empl_jefe = @empleado
	OPEN cursor_subempleados
		FETCH NEXT FROM cursor_subempleados INTO @subEmpleado
		WHILE(@@FETCH_STATUS = 0)
			BEGIN
				--ACCIONES
				SET @empleadosACargoIndirectos = @empleadosACargoIndirectos + dbo.getEmpleadosACargo(@subEmpleado)
				FETCH NEXT FROM cursor_subempleados INTO @subEmpleado
			END
	CLOSE cursor_subempleados
	DEALLOCATE cursor_subempleados
	RETURN @empleadosACargoIndirectos + @empleadosACargoDirectos
end


create procedure ej31proc
as
	begin
		-- tengo que preguntar que jefe tiene mas de 15 empleados y averiguar cuantos empleados tiene
		--despues tengo que encontrar jefes para poder distribuir esa cantidad x de empleados
		--pero puede que a un solo jefe no le entren esa cantidad x de empleados y haya que distribuirla en varios nuevos jefes

		-- si no se pueden distribuir esos empleados en varios subjefes, se los metemos a el gerente general.
	end
go

select * from Empleado 
select E.empl_codigo,dbo.getEmpleadosACargo(E.empl_codigo) from Empleado E



