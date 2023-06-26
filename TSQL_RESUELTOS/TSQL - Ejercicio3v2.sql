/*3. Cree el/los objetos de base de datos necesarios para corregir la tabla empleado
en caso que sea necesario. Se sabe que debería existir un único gerente general
(debería ser el único empleado sin jefe). Si detecta que hay más de un empleado
sin jefe deberá elegir entre ellos el gerente general, el cual será seleccionado por
mayor salario. Si hay más de uno se seleccionara el de mayor antigüedad en la
empresa. Al finalizar la ejecución del objeto la tabla deberá cumplir con la regla
de un único empleado sin jefe (el gerente general) y deberá retornar la cantidad
de empleados que había sin jefe antes de la ejecución.*/

ALTER PROC Ejercicio3v2

AS
DECLARE @GerenteGral numeric(6,0) = ( 
										SELECT TOP 1 empl_codigo
										FROM Empleado
										ORDER BY empl_salario DESC, empl_ingreso ASC
									)
DECLARE @Modif numeric(6,0)

WHILE (
		SELECT COUNT(*)
		FROM Empleado E
		WHERE E.empl_jefe IS NULL
	) > 1 
BEGIN
UPDATE Empleado SET empl_jefe = @GerenteGral
	WHERE empl_jefe IS NULL
		AND empl_codigo <> @GerenteGral

SET @Modif = @Modif + 1
PRINT @Modif
END


EXEC Ejercicio3v2