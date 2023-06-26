/*11. Cree el/los objetos de base de datos necesarios para que dado un código de
empleado se retorne la cantidad de empleados que este tiene a su cargo (directa o
indirectamente). Solo contar aquellos empleados (directos o indirectos) que
tengan un código mayor que su jefe directo.*/


CREATE PROC Ejercicio11v2 (@CodEmpl numeric(6,0), @CantEmplACargo int OUTPUT)
AS
BEGIN
	SET @CantEmplACargo = 0
	DECLARE @CodEmplAux numeric(6,0)
	DECLARE cursor_empleado CURSOR FOR SELECT E.empl_codigo
										FROM Empleado E
										WHERE empl_jefe = @CodEmpl
	OPEN cursor_empleado
	FETCH NEXT from cursor_empleado
	INTO @CodEmplAux
	WHILE @@FETCH_STATUS = 0
	BEGIN
		





		SET @CantEmplACargo = @CantEmplACargo + 1
	FETCH NEXT from cursor_empleado
	INTO @CodEmplAux
	END
	CLOSE cursor_empleado
	DEALLOCATE cursor_empleado
END
GO



/*
DECLARE @Cantidad_de_empleados_a_cargo int
EXEC Ejercicio11v2 1,@CantEmplACargo = @Cantidad_de_empleados_a_cargo OUTPUT
SELECT @Cantidad_de_empleados_a_cargo AS [Vendedor que mas vendio]


SELECT * FROM EMPLEADO
where empl_jefe = 1
*/

