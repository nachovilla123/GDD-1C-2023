/*4. Cree el/los objetos de base de datos necesarios para actualizar la columna de
empleado empl_comision con la sumatoria del total de lo vendido por ese
empleado a lo largo del último año. Se deberá retornar el código del vendedor
que más vendió (en monto) a lo largo del último año.*/

ALTER PROC Ejercicio4 (@EmplQueMasVendio numeric(6,0) OUTPUT)
AS
BEGIN
/*SET @EmplQueMasVendio = (
										SELECT TOP 1 empl_codigo
										FROM Empleado
											INNER JOIN Factura
												ON fact_vendedor = empl_codigo
												WHERE YEAR(fact_fecha) = (
																			SELECT TOP 1 YEAR(fact_fecha)
																			FROM Factura
																			ORDER BY fact_fecha DESC
																			)
												GROUP BY empl_codigo
												ORDER BY SUM(fact_total) DESC
										
										)*/

UPDATE Empleado Set empl_comision = (
										SELECT SUM(F.fact_total)
										FROM Factura F
												WHERE YEAR(fact_fecha) = (
																			SELECT TOP 1 YEAR(fact_fecha)
																			FROM Factura
																			ORDER BY fact_fecha DESC
																			)
													AND F.fact_vendedor = empl_codigo 
									)

set @EmplQueMasVendio = (SELECT TOP 1 empl_codigo
						   FROM Empleado
						   ORDER BY empl_comision DESC)
RETURN
END


DECLARE @vendedor_que_mas_vendio numeric(6,0)
EXEC Ejercicio4 @EmplQueMasVendio = @vendedor_que_mas_vendio OUTPUT
SELECT @vendedor_que_mas_vendio AS [Vendedor que mas vendio]

/*
SELECT E.empl_codigo,SUM(F.fact_total)
FROM Factura F
	INNER JOIN Empleado E
		ON E.empl_codigo = F.fact_vendedor
WHERE YEAR(fact_fecha) = (
							SELECT TOP 1 YEAR(fact_fecha)
							FROM Factura
							ORDER BY fact_fecha DESC
							)
GROUP BY E.empl_codigo
ORDER BY 2 DESC
*/

SELECT * FROM Empleado