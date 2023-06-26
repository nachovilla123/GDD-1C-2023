/*11. Cree el/los objetos de base de datos necesarios para que dado un c�digo de
empleado se retorne la cantidad de empleados que este tiene a su cargo (directa o
indirectamente). Solo contar aquellos empleados (directos o indirectos) que
tengan un c�digo mayor que su jefe directo.*/

CREATE FUNCTION dbo.Ejercicio11v4 (@Jefe numeric(6,0))
RETURNS int

AS
BEGIN
	DECLARE @CantEmplACargo int = 0
	DECLARE @JefeAux numeric(6,0) = @Jefe
	DECLARE @CodEmplAux numeric(6,0)
	

	IF NOT EXISTS (SELECT * FROM EMPLEADO WHERE empl_jefe = @Jefe)
	BEGIN
		RETURN @CantEmplACargo
	END

	SET @CantEmplACargo = (
							SELECT COUNT(*)
							FROM Empleado
							WHERE empl_jefe = @Jefe AND empl_codigo > @Jefe)

	DECLARE cursor_empleado CURSOR FOR SELECT E.empl_codigo
										FROM Empleado E
										WHERE empl_jefe = @Jefe
	OPEN cursor_empleado
	FETCH NEXT from cursor_empleado
	INTO @JefeAux
	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @CantEmplACargo = @CantEmplACargo + dbo.Ejercicio11v4(@JefeAux)	
	FETCH NEXT from cursor_empleado
	INTO @JefeAux
	END
	CLOSE cursor_empleado
	DEALLOCATE cursor_empleado

	RETURN @CantEmplACargo
END
GO

SELECT dbo.Ejercicio11v4(6)