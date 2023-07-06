/*27. Se requiere reasignar los encargados de stock de los diferentes depósitos. Para
ello se solicita que realice el o los objetos de base de datos necesarios para
asignar a cada uno de los depósitos el encargado que le corresponda,
entendiendo que el encargado que le corresponde es cualquier empleado que no
es jefe y que no es vendedor, o sea, que no está asignado a ningun cliente, se
deberán ir asignando tratando de que un empleado solo tenga un deposito
asignado, en caso de no poder se irán aumentando la cantidad de depósitos
progresivamente para cada empleado.*/

CREATE PROC dbo.ejercicio27
AS
BEGIN
	declare @depoCod char(2)
	declare cursor_depo CURSOR FOR SELECT depo_codigo
								   FROM DEPOSITO
	OPEN cursor_depo
	FETCH NEXT FROM cursor_depo
	INTO @depoCod
	WHILE @@FETCH_STATUS = 0
	BEGIN
		UPDATE DEPOSITO SET depo_encargado = (
													SELECT TOP 1 empl_codigo
													FROM Empleado
														INNER JOIN DEPOSITO
															ON depo_encargado = empl_codigo
													WHERE empl_codigo NOT IN (
																				SELECT empl_jefe
																				FROM Empleado
																				WHERE empl_jefe IS NOT NULL)
																				
														AND empl_codigo NOT IN (
																				SELECT clie_vendedor
																				FROM Cliente
																				WHERE clie_vendedor IS NOT NULL
																				)

													
													GROUP BY empl_codigo
													ORDER BY COUNT(*) ASC
													)
			WHERE depo_codigo = @depoCod
		FETCH NEXT FROM cursor_depo
		INTO @depoCod
		END
		CLOSE cursor_depo
		DEALLOCATE cursor_depo
END
GO