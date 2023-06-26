/*11. Cree el/los objetos de base de datos necesarios para que dado un código de
empleado se retorne la cantidad de empleados que este tiene a su cargo (directa o
indirectamente). Solo contar aquellos empleados (directos o indirectos) que
tengan un código mayor que su jefe directo.*/


ALTER PROC Ejercicio11 (@CodEmpl numeric(6,0), @CantEmplACargo int OUTPUT)
AS
BEGIN
	SET @CantEmplACargo = 0
	SET @CantEmplACargo = @CantEmplACargo + (
												SELECT COUNT(*)
												FROM Empleado
												WHERE empl_jefe = @CodEmpl
												)
RETURN
END


/*
DECLARE @Cantidad_de_empleados_a_cargo int
EXEC Ejercicio11 9,@CantEmplACargo = @Cantidad_de_empleados_a_cargo OUTPUT
SELECT @Cantidad_de_empleados_a_cargo AS [Vendedor que mas vendio]


SELECT count(*) FROM EMPLEADO
where empl_jefe = 9
*/

