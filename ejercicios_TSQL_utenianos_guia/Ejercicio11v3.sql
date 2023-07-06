/*11. Cree el/los objetos de base de datos necesarios para que dado un código de
empleado se retorne la cantidad de empleados que este tiene a su cargo (directa o
indirectamente). Solo contar aquellos empleados (directos o indirectos) que
tengan un código mayor que su jefe directo.*/

ALTER FUNCTION Ejercicio11v3 (@CodEmpl numeric(6,0))
RETURNS int
AS
BEGIN 

	
	DECLARE @cant int = 0
	SELECT @cant = @cant + SUM(dbo.Ejercicio11v3(empl_codigo))
	FROM Empleado
	WHERE empl_jefe = @CodEmpl
		AND empl_codigo > @CodEmpl
	RETURN @cant
END
GO
/*
SELECT dbo.Ejercicio11v3(2)


SELECT*/