/*19. Cree el/los objetos de base de datos necesarios para que se cumpla la siguiente
regla de negocio automáticamente “Ningún jefe puede tener menos de 5 años de
antigüedad y tampoco puede tener más del 50% del personal a su cargo
(contando directos e indirectos) a excepción del gerente general”. Se sabe que en
la actualidad la regla se cumple y existe un único gerente general.*/

CREATE TRIGGER dbo.ejercicio19 ON Empleado FOR INSERT,UPDATE
AS
BEGIN
	DECLARE @emplCod numeric (6,0),@emplJefe numeric (6,0)
	DECLARE cursor_inserted CURSOR FOR SELECT empl_codigo,empl_jefe
										FROM inserted
	OPEN cursor_inserted
	FETCH NEXT FROM cursor_inserted
	INTO @emplCod,@emplJefe
	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF dbo.calculoDeAntiguedad(@emplCod) < 5
		BEGIN
			PRINT 'El empleado no puede tener menos de 5 años de antiguedad'
			ROLLBACK
		END

		ELSE IF dbo.cantidadDeSubordinados(@emplCod) > (
															SELECT COUNT(*)*0.5
															FROM Empleado
															)
				AND @emplJefe <> NULL
		BEGIN
			PRINT 'El empleado no puede tener mas del 50% del personal a su cargo'
			ROLLBACK
		END
	FETCH NEXT FROM cursor_inserted
	INTO @emplCod,@emplJefe
	END
	CLOSE cursor_inserted
	DEALLOCATE cursor_inserted
END
GO


ALTER FUNCTION dbo.calculoDeAntiguedad (@empleado numeric(6,0))
RETURNS int
AS
BEGIN
	DECLARE @todaysDate smalldatetime = GETDATE()
	DECLARE @antiguedad int = 0
	SET @antiguedad = DATEDIFF(year,(SELECT empl_ingreso
										FROM Empleado
										WHERE @empleado = empl_codigo
										),@todaysDate
								)
	RETURN @antiguedad
END
GO

CREATE FUNCTION dbo.cantidadDeSubordinados (@Jefe numeric(6,0))
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
		SET @CantEmplACargo = @CantEmplACargo + dbo.cantidadDeSubordinados(@JefeAux)
			
	FETCH NEXT from cursor_empleado
	INTO @JefeAux
	END
	CLOSE cursor_empleado
	DEALLOCATE cursor_empleado

	RETURN @CantEmplACargo
END
GO