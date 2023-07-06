/*24. Se requiere recategorizar los encargados asignados a los depositos. Para ello
cree el o los objetos de bases de datos necesarios que lo resueva, teniendo en
cuenta que un deposito no puede tener como encargado un empleado que
pertenezca a un departamento que no sea de la misma zona que el deposito, si
esto ocurre a dicho deposito debera asignársele el empleado con menos
depositos asignados que pertenezca a un departamento de esa zona.*/


CREATE PROC dbo.ejercicio24
AS
BEGIN
	
	declare @depoCodigo char(2)
	declare @depoEncargado numeric(6,0)
	declare @nuevoDepoEncargado numeric(6,0)
	declare @depoZona char(3)
	declare cursor_zona CURSOR FOR SELECT D.depo_codigo,D.depo_encargado,D.depo_zona
									FROM DEPOSITO D
										INNER JOIN Empleado
											ON empl_codigo = D.depo_encargado
									WHERE empl_departamento <> (
																	SELECT depa_codigo
																	FROM Departamento
																	WHERE depa_zona = D.depo_zona)
	
	OPEN cursor_zona
	FETCH NEXT FROM cursor_zona
	INTO @depoCodigo,@depoEncargado,@depoZona
	WHILE @@FETCH_STATUS = 0
	BEGIN
			SET @nuevoDepoEncargado = (
										SELECT TOP 1 empl_codigo
										FROM Empleado
											INNER JOIN DEPOSITO
												ON depo_encargado = empl_codigo
											INNER JOIN Departamento
												ON depa_codigo = empl_departamento
										WHERE depa_zona = @depoZona
										GROUP BY empl_codigo
										ORDER BY COUNT(*) ASC
										)
			UPDATE DEPOSITO SET depo_encargado = @nuevoDepoEncargado WHERE depo_codigo = @depoCodigo
	FETCH NEXT FROM cursor_zona
	INTO @depoCodigo,@depoEncargado,@depoZona
	END
	CLOSE cursor_zona
	DEALLOCATE cursor_zona
END
GO
