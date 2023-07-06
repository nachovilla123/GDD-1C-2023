/*
13. Cree el/los objetos de base de datos necesarios para implantar la siguiente regla
�Ning�n jefe puede tener un salario mayor al 20% de las suma de los salarios de
sus empleados totales (directos + indirectos)�. Se sabe que en la actualidad dicha
regla se cumple y que la base de datos es accedida por n aplicaciones de
diferentes tipos y tecnolog�as
*/

ALTER FUNCTION dbo.Ejercicio13Func (@Jefe numeric(6,0))
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
	/*
		SET @SueldoEmpl = (
							SELECT empl_salario
							FROM Empleado
							WHERE empl_codigo = @Jefe
							)
		RETURN @SueldoEmpl
	*/
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
		SET @SueldoEmpl = @SueldoEmpl + dbo.Ejercicio13Func(@JefeAux)	
		FETCH NEXT from cursor_empleado INTO @JefeAux
	END
	CLOSE cursor_empleado
	DEALLOCATE cursor_empleado

	RETURN @SueldoEmpl
END
GO

CREATE TRIGGER Ejercicio13 ON Empleado AFTER INSERT,UPDATE
AS
BEGIN
	IF EXISTS(
		SELECT I.empl_codigo
		FROM inserted I
		WHERE I.empl_salario >  (dbo.Ejercicio13Func(I.empl_salario) * 0.2)
		)
		BEGIN
			PRINT 'Un jefe no puede superar el 20% de la suma del sueldo total de sus empleados'
			ROLLBACK
		END
	END
GO