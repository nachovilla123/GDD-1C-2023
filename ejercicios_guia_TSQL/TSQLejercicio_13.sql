/*
13. Cree el/los objetos de base de datos necesarios para implantar la siguiente regla
“Ningún jefe puede tener un salario mayor al 20% de las suma de los salarios de
sus empleados totales (directos + indirectos)”. 

Se sabe que en la actualidad dicha regla se cumple y que la base de datos es accedida por n aplicaciones de
diferentes tipos y tecnologías
*/

ALTER FUNCTION dbo.helperEj13 (@Jefe numeric(6,0))
RETURNS decimal(12,2)

AS
BEGIN
	DECLARE @SueldoEmpl decimal(12,2)
	DECLARE @JefeAux numeric(6,0) = @Jefe
	DECLARE @CodEmplAux numeric(6,0)
	
	
	IF NOT EXISTS (SELECT * FROM EMPLEADO WHERE empl_jefe = @Jefe)
	BEGIN
		SET @SueldoEmpl = 0
		RETURN @SueldoEmpl
	END

	SET @SueldoEmpl = (
						SELECT SUM(empl_salario)
						FROM Empleado
						WHERE empl_jefe = @Jefe  --AND empl_codigo > @Jefe
						)

	DECLARE cursor_empleado CURSOR FOR SELECT E.empl_codigo
										FROM Empleado E
										WHERE empl_jefe = @Jefe
	OPEN cursor_empleado
	FETCH NEXT from cursor_empleado
	INTO @JefeAux
	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @SueldoEmpl = @SueldoEmpl + dbo.helperEj13(@JefeAux)	
		FETCH NEXT from cursor_empleado INTO @JefeAux
	END
	CLOSE cursor_empleado
	DEALLOCATE cursor_empleado

	RETURN @SueldoEmpl
END
GO