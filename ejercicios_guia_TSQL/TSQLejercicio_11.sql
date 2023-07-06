/*
11. Cree el/los objetos de base de datos necesarios para que dado un código de
empleado se retorne la cantidad de empleados que este tiene a su cargo (directa o
indirectamente). Solo contar aquellos empleados (directos o indirectos) que
tengan un código mayor que su jefe directo.
*/

alter function ej11(@jefe_en_busqueda numeric(6))
RETURNS INT
AS
BEGIN
	DECLARE @CantidadEmpleadosACargo int = 0 


	IF NOT EXISTS( SELECT * FROM Empleado E1 WHERE E1.empl_codigo = @jefe_en_busqueda)
	BEGIN
		RETURN @CantidadEmpleadosACargo
	END

	Set @CantidadEmpleadosACargo =(
									Select count(distinct E2.empl_codigo) from Empleado E2
									where E2.empl_jefe = @jefe_en_busqueda and E2.empl_codigo > @jefe_en_busqueda
								  )

	-- Ahora buscamos los empleados de forma indirecta.

	DECLARE @jefeAux numeric(6), @cantidad_empleados_aux int

	DECLARE cursor_busqueda_empleados CURSOR
	FOR SELECT 
		E3.empl_codigo,
		(
			Select count(distinct E5.empl_codigo) from Empleado E5
			where E5.empl_jefe = E3.empl_codigo and E5.empl_codigo > E3.empl_codigo
		)
		FROM Empleado E3
		where E3.empl_jefe = @jefe_en_busqueda and E3.empl_codigo > @jefe_en_busqueda

	
	OPEN cursor_busqueda_empleados
	FETCH NEXT FROM cursor_busqueda_empleados INTO @jefeAux,@cantidad_empleados_aux
	WHILE(@@FETCH_STATUS = 0)
		BEGIN
			SET @CantidadEmpleadosACargo = @CantidadEmpleadosACargo + @cantidad_empleados_aux
			FETCH NEXT FROM cursor_busqueda_empleados INTO @jefeAux,@cantidad_empleados_aux
		END
	CLOSE cursor_busqueda_empleados
	DEALLOCATE cursor_busqueda_empleados

	RETURN @CantidadEmpleadosACargo
END

select * from Empleado
SELECT E.empl_codigo , dbo.ej11(E.empl_codigo) FROM Empleado E 