/*31. Desarrolle el o los objetos de base de datos necesarios, para que un jefe no pueda
tener más de 20 empleados a cargo, directa o indirectamente, si esto ocurre
debera asignarsele un jefe que cumpla esa condición, si no existe un jefe para
asignarle se le deberá colocar como jefe al gerente general que es aquel que no
tiene jefe.*/


CREATE FUNCTION dbo.empleadosACargo (@Jefe numeric(6,0))
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


CREATE PROC dbo.ejercicio31
AS
BEGIN
	DECLARE @jefe numeric(6,0)
	DECLARE @nuevoJefe numeric(6,0)
	DECLARE cursor_jefe CURSOR FOR SELECT empl_codigo
								   FROM Empleado
								   WHERE empl_codigo IN (
															SELECT empl_jefe
															FROM Empleado
															WHERE empl_jefe IS NOT NULL
														)
	OPEN cursor_jefe
	FETCH NEXT FROM cursor_jefe
	INTO @jefe
	WHILE @@FETCH_STATUS = 0
	BEGIN
		 IF dbo.empleadosACargo(@jefe) > 20
		 BEGIN
			SET @nuevoJefe = (
									SELECT empl_codigo
									FROM Empleado
									WHERE dbo.empleadosACargo(empl_codigo) < 20 AND dbo.empleadosACargo(empl_codigo) >= 1
									)
			IF @nuevoJefe IS NOT NULL
			BEGIN
				UPDATE Empleado SET empl_jefe = @nuevoJefe WHERE empl_codigo = @jefe
			END
			ELSE
			BEGIN
				UPDATE Empleado SET empl_jefe = (
													SELECT empl_codigo
													FROM Empleado
													WHERE empl_jefe IS NULL
												)
					WHERE empl_codigo = @jefe
			END
		END
		FETCH NEXT FROM cursor_jefe
		INTO @jefe
	END
	CLOSE cursor_jefe
	DEALLOCATE cursor_jefe
END
GO		